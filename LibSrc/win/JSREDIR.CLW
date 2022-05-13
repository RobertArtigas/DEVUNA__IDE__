 MEMBER

!-----------------------------------------------------------------------------!
! J&S Redirection Class Build .9901
! Class Source
! Copyright (c) 2000 by J&S Software Co. (jeff@jssoftware.com)
!-----------------------------------------------------------------------------!
!The contents of this file are subject to the CoveComm Inc. Developers Open 
!Source Public License Version 1.0 (the "License"); you may not use this 
!product except in compliance with the License. You may obtain a copy of 
!the License at http://www.clarionmag.com/common/dosl.html. Software 
!distributed under the License is distributed on an "AS IS" basis, WITHOUT 
!WARRANTY OF ANY KIND, either express or implied. See the License for the 
!specific language governing rights and limitations under the License. 
!The Original Code is Copyright (c) by J&S Software Co., released
!November 28, 2000. The Initial Developer of the Original Code is Jeff Slarve. 
!-----------------------------------------------------------------------------!

OMIT('END***', _C55_)
_ABCDllMode_        EQUATE(0)
_ABCLinkMode_       EQUATE(1)
END***

   map
     DeepMkDir(String pPath)
     FixPath(String pInPath),String
     ExtractRelativePath(String pInPath),String
     ExtractRootPath(),String
     module('')
       FNSplit(*CSTRING Path, *CSTRING Drv, *CSTRING Dir, *CSTRING Nme, *CSTRING Ext),SIGNED,PROC,RAW,NAME('_fnsplit')
       MkDir(*CSTRING),SHORT,RAW,PROC,NAME('_mkdir')
     end
   end

PathQ            Queue,Type
Name               String(FILE:MaxFileName)
                 end
RedirQ           Queue,Type
Mask               String(100)
Path               &PathQ
                 end
MacroQ           Queue,Type
Macro              String(20)
Replacement        String(FILE:MaxFilePath)
                 end
RecurseQ         QUEUE,TYPE
Name               CSTRING(FILE:MaxFilePath+FILE:MaxFileName+1)
SavePosition       STRING(4)
                 END

  Include('JSRedir.inc'),ONCE

!============================================================================================================================================================
JSRedirClass.AddDefaultMacros Procedure
!Virtual - Adds whatever macros that would be desired.
!============================================================================================================================================================

  Code
  
  Self.AddMacro('ROOT', ExtractRootPath())
  Self.AddMacro('PATH', FixPath(LongPath()))

!============================================================================================================================================================
JSRedirClass.AddMacro  Procedure(String pMacro,String pReplacement)
!Adds a macro to the macro queue
!============================================================================================================================================================

  Code

  If Self.MacroQ &= NULL
    Return
  end
  Self.MacroQ.Macro = '%' &  Upper(Clip(pMacro)) & '%'
  Get(Self.MacroQ,Self.MacroQ.Macro)
  If ErrorCode()
    Add(Self.MacroQ)
  end
  Self.MacroQ.Macro       = '%' &  Upper(Clip(pMacro)) & '%'
  Self.MacroQ.Replacement = pReplacement
  Put(Self.MacroQ)

!============================================================================================================================================================
JSRedirClass.Construct Procedure
!============================================================================================================================================================

  Code

  Self.RedirQ &= NEW RedirQ
  Free(Self.RedirQ)
  Clear(Self.RedirQ)
  Self.MacroQ &= NEW MacroQ
  Free(Self.MacroQ)
  Clear(Self.MacroQ)
  Self.AddDefaultMacros()
  SELF.RecurseQ &= NEW RecurseQ
  FREE(SELF.RecurseQ)
  CLEAR(SELF.RecurseQ)

!============================================================================================================================================================
JSRedirClass.Destruct Procedure
!============================================================================================================================================================

  Code

  If NOT Self.RedirQ &= NULL
    Self.Reset()
    Dispose(Self.RedirQ)
  end
  If NOT Self.MacroQ &= NULL
    Dispose(Self.MacroQ)
  end
  IF NOT SELF.RecurseQ &= NULL
    DISPOSE(SELF.RecurseQ)
  END

!============================================================================================================================================================
JSRedirClass.FileDialog     Procedure(String pTitle,*String pFileName,String pExtensions,Long pFlags,Byte ReturnRelativePath=False)
!Just like the standard Clarion FileDialog(), but it has the option to reduce the filename to just the relative path
!============================================================================================================================================================
ReturnVal Byte
  Code
  
  pFlags = BOR(pFlags,FILE:KeepDir)
  ReturnVal = FileDialog(pTitle,pFileName,pExtensions,pFlags)
  If ReturnVal
    pFileName = Self.ReduceFileName(pFileName,ReturnRelativePath) 
  end
  Return ReturnVal


!============================================================================================================================================================
JSRedirClass.FindFilePath       Procedure(String pShortName,*String pFullName,Byte Suggest=False)
!Searches the paths in the RedirQ for a matching filename. If it finds it, it returns the full path.
!============================================================================================================================================================
Ndx1          Long
Ndx2          Long
SuggestString CString(FILE:MaxFilePath+FILE:MaxFileName+1)
ReturnString  CString(FILE:MaxFilePath+FILE:MaxFileName+1)

  Code

  ReturnString  = Clip(pShortName)
  SuggestString = ''
  pFullName    = ReturnString
  If NOT pFullName
    Return True
  end
  If Exists(LongPath(pFullName))
    pFullName = LongPath(pFullName)
    Return True
  end
  Loop Ndx1 = 1 to Records(Self.RedirQ)
    Get(Self.RedirQ,Ndx1)
    If MATCH(Clip(pShortName),Clip(Self.RedirQ.Mask),MATCH:Wild+MATCH:NoCase)
      Loop Ndx2 = 1 to Records(Self.RedirQ.Path)
        Get(Self.RedirQ.Path,Ndx2)
        ReturnString = LongPath(FixPath(Self.RedirQ.Path.Name) & Clip(pShortName))
        If Exists(ReturnString)
          pFullName = ReturnString
          Return True
        end
        If NOT SuggestString
          SuggestString = ReturnString
        end
      end
    end
  end
  If Suggest
    If SuggestString
      pFullName = SuggestString
      Return True
    end
  end
  Return False

!============================================================================================================================================================
JSRedirClass.ParseRedirFile Procedure(String pRedirFileName,String pSection,Byte Validate=False)
!Loops through a redir file and extracts the path info to fill the queue
!============================================================================================================================================================

RedirFileName  CSTRING(FILE:MaxFilePath+FILE:MaxFileName+1),Static
RedirFile      File,Driver('ASCII'),Create,Name(RedirFileName),PRE(R)
Record             Record
S                    String(1000)
                   end
                 end

  Code

 SetCursor(CURSOR:Wait)
 RedirFileName = Clip(pRedirFileName)
 Open(RedirFile)
 If ErrorCode()
   Return 1
 end
 Set(RedirFile)
 Loop
   Next(RedirFile)
   If ErrorCode() then break.
   If Instring(UPPER('[' & Clip(pSection) & ']'),Upper(R:S),1,1)
     Loop
       Next(RedirFile)
       If ErrorCode() OR Instring('[',R:S,1,1)
         Do ProcedureReturn
       end
       Self.ParseLine(R:S)
     end
   end
 end
 Do ProcedureReturn

ProcedureReturn Routine

  Close(RedirFile)
  SetCursor()
  If Validate
    Self.ValidateRedirQ(1,1)
  end
  Return 0

!============================================================================================================================================================
JSRedirClass.ParseRedirString   Procedure(String pRedirString,Byte Validate=False)
!Similar to ParseRedirFile(), only it looks in a string (or MEMO)
!============================================================================================================================================================
Ndx1 Long
Ndx2 Long

  Code
  
  If NOT Clip(pRedirString) then Return 0.
  Ndx1 = 1
  Loop 
    Ndx2 = Instring('<13,10>',pRedirString,1,Ndx1)
    If NOT Ndx2 
      If Len(Clip(pRedirString)) > Ndx1
        Ndx2 = Len(Clip(pRedirString)) + 1
      else
        Break
      end
    end  
    Self.ParseLine(pRedirString[Ndx1 : Ndx2-1])
    Ndx1 = Ndx2 + 2
  end
  If Validate
    Self.ValidateRedirQ(1,1)
  end
  Return 1
  

!============================================================================================================================================================
JSRedirClass.ParseLine  Procedure(String pLine)
!PRIVATE - Called by the ParseRedirFile() ParseRedirString() methods
!Parses the line and adds the paths to the RedirQ
!============================================================================================================================================================
Ndx1   Long
Ndx2   Long
S      String(1000)
  Code

  If NOT Clip(pLine) then Return.
  S = Self.ReplaceMacros(pLine)
  Ndx2 = Instring('=',S,1,1)
  If NOT Ndx2 then Return.
  Self.RedirQ.Mask = S[1:Ndx2-1]
  Self.RedirQ.Path &= NEW PathQ
  Add(Self.RedirQ)
  Loop
    Ndx1 = Ndx2+1
    Ndx2 = Instring(';',S,1,Ndx1)
    If NOT Ndx2
      If Len(Clip(S)) > Ndx1
        Ndx2 = Len(Clip(S)) + 1
      else
        Break
      end
    end
    Self.RedirQ.Path.Name = Clip(Left(S[Ndx1 : Ndx2-1]))
    Add(Self.RedirQ.Path)
  end

!============================================================================================================================================================
JSRedirClass.ReduceFileName     Procedure(String pLongName,Byte ReturnRelativePath=False)
!Removes the parts of a filename that would be handled by the redir file. 
!============================================================================================================================================================
Path      CString(FILE:MaxFilePath+FILE:MaxFileName+1)
Drive     CString(10)
Dir       CString(FILE:MaxFilePath+1)
Name      CString(FILE:MaxFileName+1)
Ext       CString(30)
TestPath  CString(FILE:MaxFilePath+FILE:MaxFileName+1)
Ndx1      Long
Ndx2      Long

  CODE

  If ~PLongName
    Return('')
  end
  Path=Clip(pLongName)
  FNSplit(Path,Drive,Dir,Name,Ext)

  Loop Ndx1 = 1 to Records(Self.RedirQ)
    Get(Self.RedirQ,Ndx1)
    If MATCH(Name & Ext,Clip(Self.RedirQ.Mask),MATCH:Wild+MATCH:NoCase)
      Loop Ndx2 = 1 to Records(Self.RedirQ.Path)
        Get(Self.RedirQ.Path,Ndx2)
        If Upper(LongPath(FixPath(Self.RedirQ.Path.Name))) = Upper(LongPath(FixPath(Dir)))
          Return Choose(ReturnRelativePath=True,ExtractRelativePath(Dir),'') & Name & Ext
        end
      end
    end
  end

  Return Clip(Choose(ReturnRelativePath=True,ExtractRelativePath(pLongName),pLongName))

!============================================================================================================================================================
JSRedirClass.ReplaceMacros      Procedure(String pText)
!Replaces the "Macros" that might be contained within the Redir file, such as %ROOT%
!============================================================================================================================================================
RSize     Equate(1000)
ReturnVal String(RSize)
Rec       Long
Len       Byte
Ndx1      Long
Ndx2      Long

  Code

  ReturnVal = pText
  Loop Rec = 1 to Records(Self.MacroQ)
    Get(Self.MacroQ,Rec)
    Len = Len(Clip(Self.MacroQ.Macro))
    Ndx2 = 1
    Loop
      Ndx1 = Instring(Clip(Self.MacroQ.Macro),ReturnVal,1,Ndx2)
      If NOT Ndx1 then break.
      IF Ndx1 = 1
        ReturnVal = Clip(Self.MacroQ.Replacement) & ReturnVal[Len+1 : RSize]
        Ndx2 = Len(Clip(Self.MacroQ.Replacement)) + 1
      else
        ReturnVal = ReturnVal[1: Ndx1 - 1] & Clip(Self.MacroQ.Replacement) & ReturnVal[Ndx1+Len : RSize]
        Ndx2 = Ndx1 + Len(Clip(Self.MacroQ.Replacement)) - LEN + 1
      end
    end
  end
  Return Clip(ReturnVal)

!============================================================================================================================================================
JSRedirClass.Reset              Procedure
!Kills the current redirq and prepares for re-parsing
!============================================================================================================================================================

  Code
  
  If NOT Self.RedirQ &= NULL
    Loop
      Get(Self.RedirQ,1)
      If ErrorCode() then break.
      If NOT Self.RedirQ.Path &= NULL
        Dispose(Self.RedirQ.Path)
      end
      Delete(Self.RedirQ)
    end
    Clear(Self.RedirQ)
  end
  If NOT Self.MacroQ &= NULL
    Free(Self.MacroQ)
    Clear(Self.MacroQ)
  end
  Self.AddDefaultMacros

!============================================================================================================================================================
JSRedirClass.ValidateRedirQ     Procedure(Byte Verbose=False,Byte CreateFolders=False)
!Validates that the paths in the redir exist
!============================================================================================================================================================
Ndx1          Long
Ndx2          Long
SavePath      CString(FILE:MaxFilePath+1)
ReturnVal     Byte
  Code
  
  ReturnVal = True
  SavePath = Path()
  If NOT Self.RedirQ &= NULL
    Loop Ndx1 = 1 to Records(Self.RedirQ)
      Get(Self.RedirQ,Ndx1)
      If NOT Self.RedirQ.Path &= NULL
        Loop Ndx2 = 1 to Records(Self.RedirQ.Path)
          Get(Self.RedirQ.Path,Ndx2)
          SetPath(SavePath)
          SetPath(LongPath(Self.RedirQ.Path.Name))
          If ErrorCode()
            Returnval = False
            If Verbose
              If CreateFolders
                If Message('The path: "' & Clip(LongPath(Self.RedirQ.Path.Name)) & '" does not exist.||Would you like to create it now?','Invalid Path',ICON:Exclamation,Button:Yes+Button:No,Button:Yes) = Button:Yes
                  DeepMkDir(LongPath(Self.RedirQ.Path.Name))
                end
              else
                Message('The path: "' & Clip(LongPath(Self.RedirQ.Path.Name)) & '" does not exist','Invalid Path',ICON:Exclamation)
              end  
            elsif CreateFolders
              DeepMkDir(LongPath(Self.RedirQ.Path.Name))
            end
          end
        end
      end
    end
  end
  SetPath(SavePath)
  Return ReturnVal

!============================================================================================================================================================
DeepMkDir Procedure(String pPath)
!============================================================================================================================================================
MakePath CString(File:MaxFilePath)
Ndx1     Long
Ndx2     Long
PathLen  Long
SavePath CString(File:MaxFilePath)

  Code

  PathLen  = Len(Clip(pPath))
  SavePath = LongPath()
  SetPath(pPath)
  If ErrorCode()
    Ndx2 = 1
    Loop
      Ndx1 = Instring('\', pPath, 1, Ndx2)
      If NOT Ndx1
        If Ndx2 <= PathLen
          Ndx1 = PathLen
          Ndx2 = Ndx1
        else
          Break
        end
      end
      MakePath = pPath[1:Ndx1]
      SetPath(MakePath)
      If ErrorCode()
        If MkDir(MakePath)
          Message('Error creating: ' & MakePath,'Error!',Icon:Exclamation)
          Break
        end
      end
      Ndx2 = Ndx1 + 1
    end
  end
  SetPath(SavePath)

!============================================================================================================================================================
ExtractRelativePath  PROCEDURE(String pInPath)
!Extracts the application path from the full path of a file
!============================================================================================================================================================
Ndx      Long
Len1     Short
Len2     Short
TempPath CSTRING(File:MaxFilePath+FILE:MaxFileName+1)

  Code

  TempPath = Clip(LongPath(pInPath))
  Ndx = Instring(Upper(LongPath()),Upper(TempPath),1,1)
  If ~Ndx
    Return Clip(pInPath)
  end
  Len1 = Len(FixPath(LongPath()))
  Len2 = Len(TempPath)
  If Len1+1 < Len2
    Return TempPath[Len1+1 : Len2]
  end
  Return ''

!============================================================================================================================================================
ExtractRootPath  PROCEDURE()
!Extracts the Program's Directory
!============================================================================================================================================================
Ndx      Long
Len1     Short
Len2     Short
TempPath CSTRING(File:MaxFilePath+FILE:MaxFileName+1)

  Code

  TempPath = Command('0')
  Ndx = Instring('.EXE',Upper(TempPath),1,1)
  Loop Ndx = Ndx to 1 by -1
    If TempPath[Ndx] = '\' AND Ndx > 1
      Return LongPath(TempPath[1 : Ndx])
    end
  end
  Return FixPath(LongPath())

!============================================================================================================================================================
FixPath              PROCEDURE  (String pInPath)
!Adds a backslash to the end of a file if it doesn't exist
!============================================================================================================================================================

  CODE

 Return Clip(pInPath) & Choose(Sub(Clip(pInPath),-1,1)='\', '','\')

!============================================================================================================================================================
JSRedirClass.ParseRedirFile2    PROCEDURE(STRING pRedirFileName,STRING pSection,BYTE Validate=False,LONG Level=0)
!Loops through a redir file and extracts the path info to fill the queue
!Recurses through the {INCLUDE <filername>} keyword adding the contents to the current queues
! RA.2022.05.07.SAT: Not functional code as of yet.
!============================================================================================================================================================

RedirFileName  CSTRING(FILE:MaxFilePath+FILE:MaxFileName+1),Static
RedirFile      File,Driver('ASCII'),Create,Name(RedirFileName),PRE(R)
Record             Record
S                    String(1000)
                   end
                 end

  Code

 SetCursor(CURSOR:Wait)
 RedirFileName = Clip(pRedirFileName)
 Open(RedirFile)
 If ErrorCode()
   Return 1
 end
 Set(RedirFile)
 Loop
   Next(RedirFile)
   If ErrorCode() then break.
   If Instring(UPPER('[' & Clip(pSection) & ']'),Upper(R:S),1,1)
     Loop
       Next(RedirFile)
       If ErrorCode() OR Instring('[',R:S,1,1)
         Do ProcedureReturn
       end
       Self.ParseLine(R:S)
     end
   end
 end
 Do ProcedureReturn

ProcedureReturn Routine

  Close(RedirFile)
  SetCursor()
  If Validate
    Self.ValidateRedirQ(1,1)
  end
  Return 0
