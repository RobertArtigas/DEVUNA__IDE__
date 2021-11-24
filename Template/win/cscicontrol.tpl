#TEMPLATE(SciTPL, 'Scintilla Templates'), FAMILY('ABC')
#!
#! ================================================================================
#! Notice : Copyright (C) 2017, Devuna
#!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
#!
#!    This file is part of Devuna-Scintilla (https://github.com/Devuna/Devuna-Scintilla)
#!
#!    Devuna-Scintilla is free software: you can redistribute it and/or modify
#!    it under the terms of the MIT License as published by
#!    the Open Source Initiative.
#!
#!    Devuna-Scintilla is distributed in the hope that it will be useful,
#!    but WITHOUT ANY WARRANTY; without even the implied warranty of
#!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#!    MIT License for more details.
#!
#!    You should have received a copy of the MIT License
#!    along with Devuna-Scintilla.  If not, see <https://opensource.org/licenses/MIT>.
#! ================================================================================
#!
#! Scintilla Control Templates
#! Author:        Randy Rogers (KCR) <rrogers@devuna.com>
#! Creation Date: 07/11/2003
#!
#! This template is a derived work based on the original
#! hjTPL.tpl, hjGroup.tpw, and hjCalendar.tpw source files
#! provided by Harley Jones (HJC) 2003.03.05
#! =======================================================================================
#!
#!§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
#! Control Templates
#!§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
#!
#! =======================================================================================
#! CSciControl
#! purpose:  To add a Scintilla Control (CSciControl) to a window.
#! inputs :  ControlID - a unique ID to identify the window for notification msg processing
#! outputs:  A TEXT box is placed on the window where the scintilla control will appear.
#!           The scintilla control is initialised and added to the window manager
#!           WindowComponent list.
#!           Embed points for the derived class are generated.
#! revisions
#! =========
#! 2003.03.05   HJC initial source for HJ Calendar control
#! 2003.07.11   KCR modified for scintilla control
#! =======================================================================================
#CONTROL(CSciControl, 'Scintilla Control'),WINDOW,MULTI,DESCRIPTION('Scintilla Control - ' & %GetControlName())
#!
#PREPARE
  #SET(%ControlId,1000 + %ActiveTemplateInstance)
  #CALL(%ReadABCFiles(ABC))
  #CALL(%SetClassDefaults(ABC), 'CSciControl', 'SciControl' & %ActiveTemplateInstance, 'CSciControl')
#ENDPREPARE
#!
  CONTROLS
    TEXT,AT(, , 200, 100),USE(?sciControl:Region)
  END
#!
#BUTTON('Scintilla Control Behavior'), AT(10, , 180)
  #INSERT(%OOPPrompts(ABC))
  #SHEET, HSCROLL
    #TAB('General')
      #PROMPT('Generate Scintilla Class Code and Includes',CHECK),%GenerateScintilla,DEFAULT(%True),AT(10)
      #ENABLE(%GenerateScintilla)
        #PROMPT('Control ID (must be unique to Window):', @N4),%ControlId
        #PROMPT('Context Menu Notification Event:', @S60),%NotificationEvent,DEFAULT('EVENT:USER')
      #ENDENABLE
    #ENDTAB
    #TAB('Classes')
      #WITH(%ClassItem, 'CSciControl')
        #INSERT(%ClassPrompts(ABC))
      #END
    #ENDTAB
  #ENDSHEET
#ENDBUTTON
#!
#ATSTART
  #CALL(%ReadABCFiles(ABC))
  #CALL(%SetClassDefaults(ABC), 'CSciControl', 'SciControl' & %ActiveTemplateInstance, 'CSciControl')
  #EQUATE(%InstancePrefix, 'SciControl' & %ActiveTemplateInstance & ':')
  #FIX(%ClassItem, 'CSciControl')
  #EQUATE(%SciObjectName, %ThisObjectName)
  #EQUATE(%SciControl, %GetControlName())
  #EQUATE(%WindowManagerObject, %GetObjectName('Default', 0))
#ENDAT
#!
#AT(%CustomGlobalDeclarations),WHERE(%GenerateScintilla)
  #IF(NOT %Target32)
    #ERROR('Error: Scintilla Control requires 32-bit application')
  #ENDIF
#ENDAT
#!
#AT(%GatherObjects),WHERE(%GenerateScintilla)
#CALL(%AddObjectList(ABC), 'CSciControl')
#ENDAT
#!
#AT(%BeforeGenerateApplication),WHERE(%GenerateScintilla)
#CALL(%AddCategory(ABC),'SCI')
#CALL(%SetCategoryLocation(ABC),'SCI','SCI')
#ENDAT
#!
#AT(%WindowManagerMethodCodeSection, 'Init', '(),BYTE'), PRIORITY(8100),WHERE(%GenerateScintilla)
#FIX(%Control, %SciControl)
HIDE(%Control)
ReturnValue = %SciObjectName.Init(%Window, %Control, %ControlId)
%SciObjectName.SetContextMenuEvent(%NotificationEvent)
IF ReturnValue = Level:Benign
   %WindowManagerObject.AddItem(%SciObjectName.WindowComponent)
END
#ENDAT
#!
#AT(%SciMethodCodeSection, %ActiveTemplateInstance), PRIORITY(5000), DESCRIPTION('Parent Call'), WHERE(%ParentCallValid()),WHERE(%GenerateScintilla)
  #CALL(%GenerateParentCall(ABC))
#ENDAT
#!
#AT(%LocalProcedures),WHERE(%GenerateScintilla)
  #CALL(%SetClassItem(ABC), 'CSciControl')
  #CALL(%GenerateVirtuals(ABC), 'CSciControl', 'Local Objects|Abc Objects|Scintilla using ' & %SciControl, '%SciVirtuals(SciTPL)')
#ENDAT
#!
#AT(%SciMethodCodeSection, , 'Reset', '(BOOL Force = False)'), PRIORITY(5001),WHERE(%GenerateScintilla)
! Reset
#ENDAT
#!
#AT(%LocalDataClasses),WHERE(%GenerateScintilla)
#INSERT(%GenerateClass(ABC), 'CSciControl', 'Scintilla using ' & %SciControl)
#ENDAT
#!
#!
#!§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
#! Groups
#!§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
#!
#! =======================================================================================
#! %SciVirtuals
#! purpose:
#! inputs :
#! outputs:
#!
#! revisions
#! =========
#! 2003.03.05   HJC initial source for HJ Calendar control (%CalendarVirtuals)
#! 2003.07.11   KCR modified for scintilla control
#! =======================================================================================
#GROUP(%SciVirtuals, %TreeText, %DataText, %CodeText)
#EMBED(%SciMethodDataSection, 'Scintilla Method Data Section'), %ActiveTemplateInstance, %pClassMethod, %pClassMethodPrototype, LABEL, DATA, PREPARE(, %FixClassName(%FixBaseClassToUse('CSciControl'))), TREE(%TreeText & %DataText)
  #?CODE
  #EMBED(%SciMethodCodeSection, 'Scintilla Method Executable Code Section'), %ActiveTemplateInstance, %pClassMethod, %pClassMethodPrototype, PREPARE(, %FixClassName(%FixBaseClassToUse('CSciControl'))), TREE(%TreeText & %CodeText)
#!
#! =======================================================================================
#! %ParentCallValid
#! purpose:
#! inputs :
#! outputs:
#!
#! revisions
#! =========
#! 2003.03.05   HJC initial source
#! =======================================================================================
#GROUP(%ParentCallValid), AUTO
  #DECLARE(%RVal)
  #CALL(%ParentCallValid(ABC)), %RVal
  #RETURN(%RVal)
#!
#! =======================================================================================
#! %GetControlName
#! purpose:
#! inputs :
#! outputs:
#!
#! revisions
#! =========
#! 2003.03.05   HJC initial source
#! =======================================================================================
#GROUP(%GetControlName, %SearchReport = %False), AUTO
  #DECLARE(%RVal)
  #CALL(%GetControlName(ABC), %SearchReport), %RVal
  #RETURN(%RVal)
#!
#! =======================================================================================
#! %GetObjectName
#! purpose:
#! inputs :
#! outputs:
#!
#! revisions
#! =========
#! 2003.03.05   HJC initial source
#! =======================================================================================
#GROUP(%GetObjectName, %Flag, %Instance = 0), AUTO
  #DECLARE(%RVal)
  #CALL(%GetObjectName(ABC), %Flag, %Instance), %RVal
  #RETURN(%RVal)
#!
#! =======================================================================================
#! %HasTemplate
#! purpose:
#! inputs :
#! outputs:
#!
#! revisions
#! =========
#! 2003.03.05   HJC initial source
#! =======================================================================================
#GROUP(%HasTemplate, STRING %PassedTemplate), PRESERVE
  #FOR(%ActiveTemplate), WHERE(%ActiveTemplate = %PassedTemplate)
    #RETURN(%True)
  #ENDFOR
  #RETURN(%False)
