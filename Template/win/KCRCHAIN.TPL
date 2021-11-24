#! ================================================================================================
#!                           DEVUNA - Application Builder Class Templates
#! ================================================================================================
#! Author:  Randy Rogers (KCR) <rrogers@devuna.com>
#! Notice:  Copyright (C) 2017, Devuna
#!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
#! ================================================================================================
#!    This file is part of Devuna-Common (https://github.com/Devuna/Devuna-Common)
#!
#!    Devuna-Common is free software: you can redistribute it and/or modify
#!    it under the terms of the MIT License as published by
#!    the Open Source Initiative.
#!
#!    Devuna-Common is distributed in the hope that it will be useful,
#!    but WITHOUT ANY WARRANTY; without even the implied warranty of
#!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#!    MIT License for more details.
#!
#!    You should have received a copy of the MIT License
#!    along with Devuna-Common.  If not, see <https://opensource.org/licenses/MIT>.
#! ================================================================================================
#!
#!-------------------------------------------------------------------------------------------------
#TEMPLATE(KCR,'Devuna Application Builder Class Templates'),FAMILY('ABC')
#!
#!
#INCLUDE('KCRCNTRL.TPW')                           #! Control Templates
#INCLUDE('KCRCODE.TPW')                            #! Code Templates
#INCLUDE('KCREXTEN.TPW')                           #! Extension Templates
#INCLUDE('KCRPROCS.TPW')                           #! Procedure Templates
#INCLUDE('KCRUTIL.TPW')                            #! Utility Templates
#INCLUDE('KCRGROUP.TPW')                           #! Template Groups
#INCLUDE('KCRQEIP.TPW')                            #! Queue Edit In Place
#INCLUDE('KCR_ABBROWSE.TPW')                       #! Default Browse with Update and Select
#!
#!
#SYSTEM
 #TAB('Devuna Templates')
  #INSERT  (%SysHead)
  #BOXED   ('About Devuna Templates'),AT(5)
    #DISPLAY (''),AT(15)
    #DISPLAY ('This template 1s free software:                                       '),AT(15)
    #DISPLAY ('You can redistribute it and/or modify it under the terms of the GNU   '),AT(15)
    #DISPLAY ('General Public License as published by the Free Software Foundation,  '),AT(15)
    #DISPLAY (''),AT(15)
    #DISPLAY ('This template is distributed in the hope that they will be useful     '),AT(15)
    #DISPLAY ('but WITHOUT ANY WARRANTY; without even the implied warranty           '),AT(15)
    #DISPLAY ('of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'),AT(15)
    #DISPLAY (''),AT(15)
    #DISPLAY ('See the MIT License for more details.'),AT(15)
    #DISPLAY ('http://www.gnu.org/licenses/'),AT(15)
    #DISPLAY ('Copyright 2017 Devuna'),AT(15)
  #ENDBOXED
 #ENDTAB
#!-----------------------------------------------------------------------------------------------------------
#GROUP (%MakeHeadHiddenPrompts)
  #PROMPT('',@S50),%TplName
  #PROMPT('',@S100),%TplDescription
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%MakeHead,%xTplName,%xTplDescription)
  #SET (%TplName,%xTplName)
  #SET (%TplDescription,%xTplDescription)
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%Head)
  #IMAGE   ('KCRchain.ICO'), AT(,,175,26)
  #DISPLAY (%TplName),AT(40,3)
  #DISPLAY ('(C)1994-2017 Devuna'),AT(40,12)
  #DISPLAY ('')
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%SysHead)
  #IMAGE   ('KCRchain.ICO'), AT(,4,175,26)
  #DISPLAY ('KCRchain.TPL'),AT(40,4)
  #DISPLAY ('Devuna ABC Templates'),AT(40,14)
  #DISPLAY ('for Clarion ABC Template Applications'),AT(40,24)
  #DISPLAY ('')
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP(%SupportABCUtilityTemplate)
#SHEET
  #TAB('Complete KCR Template installation')
     #DISPLAY('This utility will prepare your version of Clarion for')
     #DISPLAY('use with Devuna ABC Templates. It will need to be')
     #DISPLAY('run after each Clarion patch that you install.')
     #DISPLAY('Please enter your Clarion root directory.')
     #PROMPT ('eg C:\SoftVelocity\Clarion10',@s100),%Root
  #ENDTAB
#ENDSHEET
  #DECLARE(%ABOOP)
  #DECLARE(%Record)
  #DECLARE(%workfile)
  #DECLARE(%TemplateSubFolder)
  #DECLARE(%TMPRecord)
  #DECLARE(%TMPRecordsRead)
  #DECLARE(%TMPRecordsWritten)

  #DECLARE(%ClassFile)
  #DECLARE(%LibsrcSubFolder)
  #DECLARE(%UpdateSectors)
  #DECLARE(%TakeAcceptedMethod)

#!
#! Add embed point for Exclude Global Class template
#!
  #IF (%cwversion => 7000)
    #SET(%TemplateSubFolder,'template\win\')
  #ELSE
    #SET(%TemplateSubFolder,'template\')
  #ENDIF
  #IF(SUB(%Root,LEN(CLIP(%root)),1) = '\')
    #SET(%ABOOP,%Root & %TemplateSubFolder & 'ABOOP.TPW')
  #ELSE
    #SET(%ABOOP,%Root & '\' & %TemplateSubFolder & 'ABOOP.TPW')
  #ENDIF
  #SET(%Workfile,'temp.$$$')
  #REMOVE(%Workfile)
  #OPEN(%workfile)
  #OPEN(%ABOOP),READ
  #LOOP
    #READ(%Record)
    #IF(%Record = %EOF)
      #BREAK
    #ENDIF
    #SET(%TMPRecordsRead,%TMPRecordsRead + 1)
    #IF (LEFT(%Record) = '#SERVICE(''ClaTPLS.DLL'',''GenReadABCFiles'')')
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #READ(%Record)
      #IF (LEFT(%Record) <> '#EMBED(%AfterReadABCFiles)                          #!Devuna modification')
        #SET(%TMPRecord,'#EMBED(%AfterReadABCFiles)                          #!Devuna modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
%Record
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #ENDIF
    #ELSE
%Record
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ENDIF
  #ENDLOOP
  #CLOSE(%ABOOP),READ
  #CLOSE(%Workfile)
  #IF(%TMPRecordsRead > 0 AND %TMPRecordsWritten > %TMPRecordsRead)
      #!only replace if there is something there.
    #REPLACE(%ABOOP,%Workfile)
  #ENDIF
  #REMOVE(%Workfile)

#!
#! Fix Up abquery.clw
#!
  #IF (%cwversion => 7000)
    #SET(%LibsrcSubFolder,'libsrc\win\')
  #ELSE
    #SET(%LibsrcSubFolder,'libsrc\')
  #ENDIF
  #IF(SUB(%Root,LEN(CLIP(%root)),1) = '\')
    #SET(%ClassFile,%Root & %LibsrcSubFolder & 'abquery.clw')
  #ELSE
    #SET(%ClassFile,%Root & '\' & %LibsrcSubFolder & 'abquery.clw')
  #ENDIF

  #SET(%TakeAcceptedMethod,%FALSE)
  #SET(%TMPRecordsRead,0)
  #SET(%TMPRecordsWritten,0)
  #OPEN(%workfile)
  #OPEN(%ClassFile),READ
  #LOOP
    #READ(%Record)
    #IF(%Record = %EOF)
      #BREAK
    #ENDIF
    #SET(%TMPRecordsRead,%TMPRecordsRead + 1)
    #IF (LEFT(%Record) = 'QueryVisual.TakeAccepted   PROCEDURE')
      #SET(%TakeAcceptedMethod,%TRUE)
    #ENDIF
    #IF (LEFT(%Record) = 'SELF.QC.GetQueries(SELF.Queries)' AND %TakeAcceptedMethod = %TRUE)
      #READ(%Record)
      #SET(%TMPRecordsRead,%TMPRecordsRead + 1)
      #IF (LEFT(%Record) <> 'END')
        #SET(%TMPRecord,'     IF ~SELF.QC.INIMgr &= NULL                 !Devuna modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'        SELF.QC.INIMgr.UpdateSectors()          !Devuna modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'        SELF.QC.GetQueries(SELF.Queries)        !Devuna modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'     END                                        !Devuna modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
%Record
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #ELSE
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #ENDIF
    #ELSIF (LEFT(%Record) = 'SELF.QC.Save(''tsMRU'') ! Save as Most Recently used.')
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #SET(%TMPRecord,'     IF ~SELF.QC.INIMgr &= NULL                 !Devuna modification')
%TMPRecord
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #SET(%TMPRecord,'        SELF.QC.INIMgr.UpdateSectors()          !Devuna modification')
%TMPRecord
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #SET(%TMPRecord,'     END                                        !Devuna modification')
%TMPRecord
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ELSE
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ENDIF
  #ENDLOOP

  #CLOSE(%ClassFile),READ
  #CLOSE(%Workfile)
  #IF(%TMPRecordsRead > 0 AND %TMPRecordsWritten > %TMPRecordsRead)
      #!only replace if there is something there.
    #REPLACE(%ClassFile,%Workfile)
  #ENDIF
  #REMOVE(%Workfile)

#!
#! Fix Up abutil.clw
#!
  #IF (%cwversion => 7000)
    #SET(%LibsrcSubFolder,'libsrc\win\')
  #ELSE
    #SET(%LibsrcSubFolder,'libsrc\')
  #ENDIF
  #IF(SUB(%Root,LEN(CLIP(%root)),1) = '\')
    #SET(%ClassFile,%Root & %LibsrcSubFolder & 'abutil.clw')
  #ELSE
    #SET(%ClassFile,%Root & '\' & %LibsrcSubFolder & 'abutil.clw')
  #ENDIF

  #SET(%TMPRecordsRead,0)
  #SET(%TMPRecordsWritten,0)
  #SET(%UpdateSectors,%FALSE)
  #OPEN(%workfile)
  #OPEN(%ClassFile),READ
  #LOOP
    #READ(%Record)
    #IF(%Record = %EOF)
      #BREAK
    #ENDIF
    #SET(%TMPRecordsRead,%TMPRecordsRead + 1)
    #IF (LEFT(%Record) = 'INIClass.UpdateSectors PROCEDURE')
       #SET(%UpdateSectors,%TRUE)
    #ENDIF
    #IF (LEFT(%Record) = 'INIClass.Fetch PROCEDURE(STRING Sector, STRING Name, STRING Default, STRING Filename)')
      #IF (%UpdateSectors = %FALSE)
        #SET(%TMPRecord,'!======================================================================================')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'! INIClass.UpdateSectors Method Devuna modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'!======================================================================================')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'INIClass.UpdateSectors PROCEDURE')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'critProc  CriticalProcedure')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'   CODE')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'   critProc.init(SELF.critSect)')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'   SELF.UpdateQueue(''__Dont_Touch_Me__'',''Sectors'',SELF.Sectors,SELF.Sectors.Family,SELF.Sectors.Item,SELF.Sectors.Type) !***')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'   RETURN')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
        #SET(%TMPRecord,'')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
%Record
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #ELSE
%Record
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #ENDIF
    #ELSE
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ENDIF
  #ENDLOOP

  #CLOSE(%ClassFile),READ
  #CLOSE(%Workfile)
  #IF(%TMPRecordsRead > 0 AND %TMPRecordsWritten > %TMPRecordsRead)
      #!only replace if there is something there.
    #REPLACE(%ClassFile,%Workfile)
  #ENDIF
  #REMOVE(%Workfile)

#!
#! Fix Up abutil.inc
#!
  #IF (%cwversion => 7000)
    #SET(%LibsrcSubFolder,'libsrc\win\')
  #ELSE
    #SET(%LibsrcSubFolder,'libsrc\')
  #ENDIF
  #IF(SUB(%Root,LEN(CLIP(%root)),1) = '\')
    #SET(%ClassFile,%Root & %LibsrcSubFolder & 'abutil.inc')
  #ELSE
    #SET(%ClassFile,%Root & '\' & %LibsrcSubFolder & 'abutil.inc')
  #ENDIF

  #SET(%TMPRecordsRead,0)
  #SET(%TMPRecordsWritten,0)
  #SET(%UpdateSectors,%FALSE)
  #OPEN(%workfile)
  #OPEN(%ClassFile),READ
  #LOOP
    #READ(%Record)
    #IF(%Record = %EOF)
      #BREAK
    #ENDIF
    #SET(%TMPRecordsRead,%TMPRecordsRead + 1)
    #IF (LEFT(%Record) = 'Sectors             &SectorQueue,PRIVATE')
      #SET(%TMPRecord,'Sectors             &SectorQueue,PROTECTED   !,PRIVATE Devuna Modification')
%TMPRecord
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ELSIF (LEFT(%Record) = 'FetchQueue          PROCEDURE(STRING Sector,STRING Name,QUEUE Q,*? F1,<*? F2>,<*? F3>,<*? F4>)')
      #SET(%TMPRecord,'FetchQueue          PROCEDURE(STRING Sector,STRING Name,QUEUE Q,*? F1,<*? F2>,<*? F3>,<*? F4>),VIRTUAL   !Devuna Modification')
%TMPRecord
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ELSIF (LEFT(%Record) = 'UpdateQueue         PROCEDURE(STRING Sector,STRING Name,QUEUE Q,*? F1,<*? F2>,<*? F3>,<*? F4>)')
      #SET(%TMPRecord,'UpdateQueue         PROCEDURE(STRING Sector,STRING Name,QUEUE Q,*? F1,<*? F2>,<*? F3>,<*? F4>),VIRTUAL   !Devuna Modification')
%TMPRecord
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ELSIF (LEFT(%Record) = 'GetSectors          PROCEDURE(<STRING Family>, <STRING Item>, <STRING Type>, SectorQueue SQ)')
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #READ(%Record)
      #SET(%TMPRecordsRead,%TMPRecordsRead + 1)
      #IF (LEFT(%Record) <> 'UpdateSectors       PROCEDURE')
        #SET(%TMPRecord,'UpdateSectors       PROCEDURE   !Devuna Modification')
%TMPRecord
        #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
      #ENDIF
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ELSE
%Record
      #SET(%TMPRecordsWritten,%TMPRecordsWritten + 1)
    #ENDIF
  #ENDLOOP

  #CLOSE(%ClassFile),READ
  #CLOSE(%Workfile)
  #IF(%TMPRecordsRead > 0 AND %TMPRecordsWritten > %TMPRecordsRead)
      #!only replace if there is something there.
    #REPLACE(%ClassFile,%Workfile)
  #ENDIF
  #REMOVE(%Workfile)

#!-----------------------------------------------------------------------------------------------------------
#GROUP(%EmbedStart)
#?!-----------------------------------------------------------------------------------------------------------
#?! KCRCHAIN.TPL   (C)1994-2017 Devuna
#?! Template: (%TplName - %TplDescription)
#IF (%EmbedID)
#?! Embed:    (%EmbedID) (%EmbedDescription) (%EmbedParameters)
#ENDIF
#?!-----------------------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------------------
#GROUP(%EmbedEnd)
#?!-----------------------------------------------------------------------------------------------------------
