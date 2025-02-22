!ABCIncludeFile

!-----------------------------------------------------------------------------!
! J&S Redirection Class Build .9902
! Class Declaration
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


OMIT('_EndOfInclude_',_JSRedirPresent_)
_JSRedirPresent_ EQUATE(1)

JSRedirClass           CLASS,MODULE('JSREDIR.CLW'),TYPE,LINK('JSREDIR.CLW',1),DLL(0)
AddDefaultMacros         Procedure,Virtual
AddMacro                 Procedure(String pMacro,String pReplacement)
Construct                Procedure
Destruct                 Procedure,Virtual
FileDialog               Procedure(String pTitle,*String pFileName,String pExtensions,Long pFlags,Byte ReturnRelativePath=False),Byte
FindFilePath             Procedure(String pShortName,*String pFullName,Byte Suggest=False,Byte PathOnly=False),Byte
ReduceFileName           Procedure(String pLongName,Byte ReturnRelativePath=False),String
ParseEnvironmentPath     Procedure(Byte Validate=False)
ParseRedirFile           Procedure(String pRedirFileName,String pSection,Byte Validate=False,<*STRING OutRF>),Byte,Proc
ParseRedirFile2          PROCEDURE(STRING pRedirFileName,STRING pSection,BYTE Validate=False,<*STRING OutRF>,LONG Level=0),BYTE,PROC
ParseRedirString         Procedure(String pRedirString,Byte Validate=False),Byte,Proc
ParseLine                Procedure(String pLine),Private
ReplaceMacros            Procedure(String pText),String,Private
Reset                    Procedure
ValidateRedirQ           Procedure(Byte Verbose=False,Byte CreateFolders=False),Byte,Proc
MacroQ                   &MacroQ,Private
RedirQ                   &RedirQType,Private
! Carl Barnes
DumpQ                    PROCEDURE(QUEUE OutQ, *STRING QLine, *STRING QMask, *LONG QPathID) !, *STRING QPath) 
FindFilePath_LastPathID  LONG 
PathIDCnt                LONG,PRIVATE 
ParsingRedWhat           String(300),Private      !e.g. [Common] X:\RedFile
! Roberto Artigas
Level                    LONG,PRIVATE
RecurseQ                 &RecurseQueue,PRIVATE
                       end

_EndOfInclude_