 Member

!-----------------------------------------------------------------------------!
! J&S Redirection Class Build .9902
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
     FixPath(String pInPath,Byte IsFolder=True),String
     ExtractRelativePath(String pInPath),String
     ExtractRootPath(),String
     module('')
       FNSplit(*CSTRING Path, *CSTRING Drv, *CSTRING Dir, *CSTRING Nme, *CSTRING Ext),SIGNED,PROC,RAW,NAME('_fnsplit')
       MkDir(*CSTRING),SHORT,RAW,PROC,NAME('_mkdir')
       GetEnv (*CSTRING),CSTRING,RAW,NAME('_getenv')
     end
   end

PathQType        Queue,Type 
PathID             LONG                     	!Carl so Can show what line got it
Name               String(FILE:MaxFileName)
NameRaw            String(FILE:MaxFileName)  	!TODO path before Macros etc
                 end
RedirQType       Queue,Type
Mask               String(255)      			!Carl made 255
LineRaw            String(512)      			!Carl added so w/o Macros
RedWhat            String(300)      			!e.g. [Common] X:\RedFile
Path               &PathQType
                 end
MacroQ           Queue,Type
Macro              String(20)
Replacement        String(FILE:MaxFilePath)
                 end

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
    Self.PathIDCnt = 100        !Carl  
    Self.RedirQ &= NEW RedirQType
    Free(Self.RedirQ)
    Clear(Self.RedirQ)
    Self.MacroQ &= NEW MacroQ
    Free(Self.MacroQ)
    Clear(Self.MacroQ)
    Self.AddDefaultMacros()

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
JSRedirClass.FindFilePath       Procedure(String pShortName,*String pFullName,Byte Suggest=False,Byte PathOnly=False)
!Searches the paths in the RedirQ for a matching filename. If it finds it, it returns the full path.
!============================================================================================================================================================
Ndx1          Long
Ndx2          Long
SuggestString CString(FILE:MaxFilePath+FILE:MaxFileName+1)
ReturnString  CString(FILE:MaxFilePath+FILE:MaxFileName+1)

  Code
  SELF.FindFilePath_LastPathID = 0 
  If NOT PathOnly
    pShortName    = FixPath(Clip(pShortName),False)
    ReturnString  = Clip(pShortName)
  else
    ReturnString  = 'Just a dummy string'
  end  
  SuggestString = ''
  pFullName    = ReturnString
  If NOT pFullName
    Return True
  end 
!Removed Jeff's code below that looks in current path. That would be the EXEs folder. Want to use %PATH%   
!  If Exists(LongPath(pFullName))    
!    Message('Finding in current folder|pFullName=' & CLIP(pFullName) &'|' & LongPath(pFullName) )
!    pFullName = LongPath(pFullName)
!    Return True
!  end
  Loop Ndx1 = 1 to Records(Self.RedirQ)
    Get(Self.RedirQ,Ndx1)
    If MATCH(Clip(pShortName),Clip(Self.RedirQ.Mask),MATCH:Wild+MATCH:NoCase)
      Loop Ndx2 = 1 to Records(Self.RedirQ.Path)
        Get(Self.RedirQ.Path,Ndx2)
        ReturnString = LongPath(FixPath(Self.RedirQ.Path.Name) & Choose(PathOnly=0,Clip(pShortName),''))
        SELF.FindFilePath_LastPathID = Self.RedirQ.Path.PathID  !Ndx1 * 1000 + Ndx2 
        !Message(FixPath(Self.RedirQ.Path.Name) & '|' & Choose(PathOnly=0,Clip(pShortName),''))
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
JSRedirClass.ParseEnvironmentPath Procedure(Byte Validate=False)
!Uses the PATH environment variable
!============================================================================================================================================================
S Cstring(32)

  Code
  
  S = 'PATH'
  Self.ParseRedirString('*.* = .;' & GetEnv(S),Validate)
  
!============================================================================================================================================================
JSRedirClass.ParseRedirFile Procedure(String pRedirFileName,String pSection,Byte Validate=False, <*STRING OutRF>)
!Loops through a redir file and extracts the path info to fill the queue
!============================================================================================================================================================

RedirFileName  CSTRING(FILE:MaxFilePath+FILE:MaxFileName+1),Static
RedirFile      File,Driver('ASCII'),Create,Name(RedirFileName),PRE(R)
Record             Record
S                    String(1000)
                   end
                 end
!BRF     BSTRING 
pB_Section_B         PSTRING(64)
InSectionWanted     BOOL        !In pSection
  Code
    IF~OMITTED(OutRF) THEN
        OutRF = CLIP(pRedirFileName) &'<13,10>' & ALL('=',LEN(CLIP(pRedirFileName)))
        !OutRF = 'Load [' & CLIP(pSection) & ']  from ' & pRedirFileName 
    END                                 
    pB_Section_B = '[' & CLIP(UPPER(pSection)) & ']' 
    Self.ParsingRedWhat = pB_Section_B &'  '&  pRedirFileName
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

      IF~OMITTED(OutRF) THEN
          OutRF = CLIP(OutRF) &'<13,10>' & R:S
      END 
      IF R:S[1] = '[' THEN   !New Section
         InSectionWanted = 0
         IF pB_Section_B = Upper(SUB(LEFT(R:S),1,LEN(pB_Section_B))) THEN  !Syntax? IMO s.b. column 1
            InSectionWanted = 1
         END 
      END                    
      IF ~InSectionWanted THEN CYCLE.       !Not in [Common]  
      Self.ParseLine(R:S)
      
!      If Instring(UPPER('[' & Clip(pSection) & ']'),Upper(R:S),1,1)
!        Loop
!          Next(RedirFile)
!          If ErrorCode() OR Instring('[',R:S,1,1)
!            Do ProcedureReturn
!          end
!          Self.ParseLine(R:S)
!        end
!      end
      
    end !Loop file read
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
  Self.ParsingRedWhat = ''
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
Ndx1    Long
Ndx2    Long
S       String(1000)
Pth     STRING(262)
Ln      LONG,AUTO 
  Code
  If NOT Clip(pLine) then Return.
  CASE SUB(pLine,1,1)
  OF '-'    ; RETURN    !a comment e.g. -- Directories only used ...
  OF '{{'   ; RETURN    !new include syntax {include C:\otherred.red}
  END 
  
  S = Self.ReplaceMacros(pLine)
  Ndx2 = Instring('=',S,1,1)
  If NOT Ndx2 then Return.
  Self.RedirQ.LineRaw = pLine
  Self.RedirQ.RedWhat = Self.ParsingRedWhat
  Self.RedirQ.Mask = S[1:Ndx2-1]
  Self.RedirQ.Path &= NEW PathQType
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
    Pth = Clip(Left(S[Ndx1 : Ndx2-1]))
    IF Pth[1]='"' THEN                  !"%ROOT%\Accessory\my images"
       Pth=LEFT(SUB(Pth,2,999))
       Ln=LEN(CLIP(Pth))
       IF Ln AND Pth[Ln]='"' THEN Pth[Ln]=''.
    END 

    !Carl I want to fix ..' and '..' to use %PATH%
        IF Pth='.' THEN                                             !Carl        
           Pth=Self.ReplaceMacros('%PATH%') 
        ELSIF Self.RedirQ.Path.Name[1]='.' THEN                                             !Carl
           Pth=Self.ReplaceMacros('%PATH%\' & Self.RedirQ.Path.Name )  !Carl if .
        END                                                                              !Carl path\.
    Self.RedirQ.Path.Name = Pth
    Self.PathIDCnt += 1
    Self.RedirQ.Path.PathID = Self.PathIDCnt    
    IF Pth THEN Add(Self.RedirQ.Path) .
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
    Self.PathIDCnt = 100        !Carl
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
Ln1 Loop Ndx1 = 1 to Records(Self.RedirQ)
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
                CASE Message('The path: "' & Clip(LongPath(Self.RedirQ.Path.Name)) & '" does not exist.' & |
                           '||Would you like to create it now?','Invalid Path',|
                           ICON:Exclamation,Button:Yes+Button:No+BUTTON:CANCEL,Button:Yes)
                OF BUTTON:CANCEL
                   BREAK Ln1 
                OF Button:Yes
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
    If pPath[1:2] = '\\' !UNC
      Ndx2 = 3
      Ndx2 = Instring('\', pPath,1,Ndx2)
      Ndx2 = Instring('\', pPath,1,Ndx2+1)
    else
      Ndx2 = 1
    end
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
FixPath              PROCEDURE  (String pInPath,Byte IsFolder=True)
!Adds a backslash to the end of a file if it doesn't exist
!============================================================================================================================================================
ReturnVal CString(File:MaxFilePath)
Ndx       Short

  CODE

 ReturnVal = Clip(pInPath)
! Loop
!   Ndx       = Instring('/',ReturnVal,1,1)                               !Replace any forward slashes with backslashes
!   If not Ndx then break.
!   ReturnVal[Ndx] = '\'
! end
 Loop Ndx = 1 to File:MaxFilePath - 1
   Case ReturnVal[Ndx]
   of '/'
     ReturnVal[Ndx] = '\'
   of '?' orof '*'
     ReturnVal[Ndx] = '_'
   end
 end
 
 Loop
   Ndx       = Instring('\\',ReturnVal,1,2)                              !If there are any doubled up backslashes, then fix it
   If not Ndx then break.
   Case Ndx
   of 1
     ReturnVal = ReturnVal[2 : Len(ReturnVal)]
   of Len(Returnval) - 1
     ReturnVal = ReturnVal[1: Len(ReturnVal) - 1]
   else
     ReturnVal = ReturnVal[1 : Ndx] & ReturnVal[Ndx+2 : Len(ReturnVal)]
   end
 end
 If IsFolder
   ReturnVal = ReturnVal & Choose(Sub(ReturnVal,-1,1)='\', '','\') !Ensure that the last character of the path is a backslash
 end  
 Return ReturnVal

!============================================================================================================================================================
JSRedirClass.DumpQ                PROCEDURE(QUEUE OutQ, *STRING QMask, *STRING QLine, *LONG QPathID) !, *STRING QPath) 
!visible q, make a tree
!============================================================================================================================================================
Ndx1          Long
Ndx2          Long  
LastRedWhat   LIKE(RedirQType.RedWhat)
    CODE
    QPathID = 0    
    Loop Ndx1 = 1 to Records(Self.RedirQ)
      Get(Self.RedirQ,Ndx1)      
      IF LastRedWhat <> Self.RedirQ.RedWhat THEN
         QMask = Self.RedirQ.RedWhat
         QLine = '={32}'
         ADD(OutQ)
         LastRedWhat = Self.RedirQ.RedWhat 
      END 
      QMask = Self.RedirQ.Mask
      QLine = Self.RedirQ.LineRaw
      ADD(OutQ)
      QLine = ''
        Loop Ndx2 = 1 to Records(Self.RedirQ.Path)
          Get(Self.RedirQ.Path,Ndx2)
          QMask = '     ' & Self.RedirQ.Path.Name       !need a Tree
          QPathID = Self.RedirQ.Path.PathID  !Ndx1 * 1000 + Ndx2 !ADDRESS(Self.RedirQ.Path.Name) 
          ADD(OutQ)
         ! ReturnString = LongPath(FixPath(Self.RedirQ.Path.Name) & Choose(PathOnly=0,Clip(pShortName),''))
        end
        QPathID = 0
    end 
      QLine = ''
      QMask = ''
      ADD(OutQ)

    Loop Ndx1 = 1 TO RECORDS(SELF.MacroQ)
         GET(SELF.MacroQ,Ndx1)
         QMask = 'Macro: ' & SELF.MacroQ.Macro
         QLine = ' = '     & SELF.MacroQ.Replacement
         ADD(OutQ)
    END          
!MacroQ           Queue,Type
!Macro              String(20)
!Replacement        String(FILE:MaxFilePath)

    return 