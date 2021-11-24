

   MEMBER('kss.clw')                                       ! This is a MEMBER module

!region Notices
! ================================================================================
! Notice : Copyright (C) 2017, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
!
!    This file is part of Devuna-KwikSourceSearch (https://github.com/Devuna/Devuna-KwikSourceSearch)
!
!    Devuna-KwikSourceSearch is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-KwikSourceSearch is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-KwikSourceSearch.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================
!endregion Notices

   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
CheckRegistration    PROCEDURE  (*CSTRING szRegistrant,*LONG ExpiryDate) ! Declare Procedure
!region Notices
! ================================================================================
! Notice : Copyright (C) 2017, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
!
!    This file is part of Devuna-KwikSourceSearch (https://github.com/Devuna/Devuna-KwikSourceSearch)
!
!    Devuna-KwikSourceSearch is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-KwikSourceSearch is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-KwikSourceSearch.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================
!endregion Notices
oHH           &tagHTMLHelp
RetVal        LONG
szSubKey      CSTRING(256)
szValueName   CSTRING('License')
hDevuna       ULONG
hKeystone     ULONG
BinaryLicense STRING(36)
bLicense      BYTE,DIM(36),OVER(BinaryLicense)
pType         ULONG
pData         ULONG
sMask         STRING('<048h,0DCh,09Ch,060h,026h,08Ah,011h,0E1h,03Dh,06Ch,005h,0B1h,09Bh,071h,04Ah,0E1h,048h,0DCh,09Ch,060h,026h,08Ah,011h,0E1h,03Dh,06Ch,005h,0B1h,09Bh,071h,04Ah,0E1h,048h,0DCh,09Ch,060h>')
bMask         BYTE,DIM(36),OVER(sMask)
i             LONG
lDate         LONG
sDate         STRING(4),OVER(lDate)
crc           LONG
sCrc          STRING(4),OVER(crc)
cc            LONG
szError       CSTRING(256)
szErrorFunc   CSTRING(64)

  CODE
    
      ExpiryDate = 113578
      szRegistrant = 'All Clarion folks'
      RetVal  = Level:Benign
      RETURN RetVal
      
      szSubKey = 'Software\Devuna\KSS'
      RetVal = kcr_RegOpenKeyEx(HKEY_CURRENT_USER,szSubKey,0,KEY_QUERY_VALUE,hDevuna)
      IF RetVal = ERROR_SUCCESS
         pType = REG_BINARY
         pData = SIZE(BinaryLicense)
         RetVal = kcr_RegQueryValueEx(hDevuna,szValueName,0,pType,ADDRESS(BinaryLicense),pData)
         IF RetVal = ERROR_SUCCESS
            LOOP i = 1 TO 36
               bLicense[i] = BXOR(bLicense[i],bMask[i])
            END
            sCrc = BinaryLicense[33 : 36]
            cc   = kcr_crc32(ADDRESS(BinaryLicense),32,0)
            IF crc = cc
               sDate = BinaryLicense[1 : 4]
               szRegistrant = BinaryLicense[5 : 32]
               ExpiryDate   = lDate
               ud.debug('ExpiryDate: ldate=' & lDate)
            ELSE
               MESSAGE('License is corrupted','Bad License',ICON:HAND)
               szRegistrant = UNREGISTERED_COPY
               ExpiryDate = TODAY()-1
               RetVal = Level:Fatal
            END
         ELSE
            szErrorFunc = 'RegQueryValueEx'
            DO HandleError
         END
         RetVal = kcr_RegCloseKey(hDevuna)

      ELSIF RetVal = ERROR_FILE_NOT_FOUND
         RetVal = kcr_RegCreateKeyEx(HKEY_CURRENT_USER,szSubKey,0,0,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,0,hDevuna,0)
         IF RetVal = ERROR_SUCCESS

            !see if registered under keystone computer resources
            szSubKey = 'Software\Keystone Computer Resources\KSS'
            RetVal = kcr_RegOpenKeyEx(HKEY_CURRENT_USER,szSubKey,0,KEY_QUERY_VALUE,hKeystone)
            IF RetVal = ERROR_SUCCESS
               pType = REG_BINARY
               pData = SIZE(BinaryLicense)
               RetVal = kcr_RegQueryValueEx(hKeystone,szValueName,0,pType,ADDRESS(BinaryLicense),pData)
               IF RetVal = ERROR_SUCCESS
                  RetVal = kcr_RegSetValueEx(hDevuna,szValueName,0,REG_BINARY,ADDRESS(BinaryLicense),SIZE(BinaryLicense))
                  IF RetVal = ERROR_SUCCESS
                     LOOP i = 1 TO 36
                        bLicense[i] = BXOR(bLicense[i],bMask[i])
                     END
                     sCrc = BinaryLicense[33 : 36]
                     cc   = kcr_crc32(ADDRESS(BinaryLicense),32,0)
                     IF crc = cc
                        sDate = BinaryLicense[1 : 4]
                        szRegistrant = BinaryLicense[5 : 32]
                        ExpiryDate   = lDate
                     ELSE
                        MESSAGE('License is corrupted','Bad License',ICON:HAND)
                        szRegistrant = UNREGISTERED_COPY
                        ExpiryDate = TODAY()-1
                        RetVal = Level:Fatal
                     END
                  ELSE
                     szErrorFunc = 'RegSetValueEx'
                     DO HandleError
                  END
               ELSE
                  szErrorFunc = 'RegQueryValueEx'
                  DO HandleError
               END
               RetVal = kcr_RegCloseKey(hKeystone)

            ELSE  !not registered
               lDate = TODAY() + 30
               BinaryLicense = sDate & UNREGISTERED_COPY
               crc = kcr_crc32(ADDRESS(BinaryLicense),32,0)
               BinaryLicense = sDate & UNREGISTERED_COPY & sCrc
               LOOP i = 1 TO 36
                  bLicense[i] = BXOR(bLicense[i],bMask[i])
               END
               RetVal = kcr_RegSetValueEx(hDevuna,szValueName,0,REG_BINARY,ADDRESS(BinaryLicense),SIZE(BinaryLicense))
               IF RetVal = ERROR_SUCCESS
                  szRegistrant = UNREGISTERED_COPY
                  ExpiryDate   = lDate
               ELSE
                  szErrorFunc = 'RegSetValueEx'
                  DO HandleError
               END
            END
            RetVal = kcr_RegCloseKey(hDevuna)
         ELSE
            szErrorFunc = 'RegCreateKeyEx'
            DO HandleError
            RetVal = Level:Fatal
         END
      ELSE
         szErrorFunc = 'RegOpenKeyEx'
         DO HandleError
         RetVal = Level:Fatal
      END
      RETURN RetVal
HandleError    ROUTINE
   cc = kcr_FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,0,RetVal,LANG_USER_DEFAULT,szError,SIZE(szError),0)
   MESSAGE(szErrorFunc & ' returned the following error:|' & szError,'Unexpected Error',ICON:HAND)
   EXIT
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
RegisterProduct PROCEDURE 

!region Notices
! ================================================================================
! Notice : Copyright (C) 2017, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
!
!    This file is part of Devuna-KwikSourceSearch (https://github.com/Devuna/Devuna-KwikSourceSearch)
!
!    Devuna-KwikSourceSearch is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-KwikSourceSearch is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-KwikSourceSearch.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================
!endregion Notices
oHH           &tagHTMLHelp
RetVal               LONG
szErrorFunc          CSTRING(64)
RegistrationKey      STRING(72)                            ! 
ReturnCode           LONG(Level:Cancel)                    ! 
Window               WINDOW('Product Registration'),AT(,,177,94),FONT('Segoe UI',10),CENTER,GRAY,SYSTEM
                       BUTTON('&Register'),AT(77,75,45,14),USE(?cmdRegister),DEFAULT
                       BUTTON('&Cancel'),AT(127,75,45,14),USE(?CancelButton)
                       PROMPT('Paste your Registration Key into the box below'),AT(10,10),USE(?RegistrationKey:Prompt)
                       TEXT,AT(24,25,128,34),USE(RegistrationKey),UPR
                       PANEL,AT(5,5,167,65),USE(?PANEL1),BEVEL(1)
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  RETURN(ReturnCode)

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
HandleError    ROUTINE
   DATA
szError       CSTRING(256)
cc            LONG

   CODE
      cc = kcr_FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,0,RetVal,LANG_USER_DEFAULT,szError,SIZE(szError),0)
      MESSAGE(szErrorFunc & ' returned the following error:|' & szError,'Unexpected Error',ICON:HAND)
   EXIT

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    
  GlobalErrors.SetProcedureName('RegisterProduct')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?cmdRegister
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(Window)                                        ! Open window
  !Setting the LineHeight for every control of type LIST/DROP or COMBO in the window using the global setting.
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  Window{Prop:Alrt,255} = CtrlShiftP
  INIMgr.Fetch('RegisterProduct',Window)                   ! Restore window settings from non-volatile store
  CorrectForOffscreen(Window)
  SELF.SetAlerts()
  oHH &= NEW tagHTMLHelp
  oHH.Init( 'kss.chm' )
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('RegisterProduct',Window)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  IF ~oHH &= NULL
    oHH.Kill()
    DISPOSE( oHH )
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
i              BYTE
j              BYTE
hiNibble       BYTE
loNibble       BYTE
szSubKey       CSTRING('SOFTWARE\Devuna\KSS')
szValueName    CSTRING('License')
hDevuna        ULONG
BinaryLicense  STRING(36)
bLicense       BYTE,DIM(36),OVER(BinaryLicense)
pType          ULONG
pData          ULONG
sMask          STRING('<048h,0DCh,09Ch,060h,026h,08Ah,011h,0E1h,03Dh,06Ch,005h,0B1h,09Bh,071h,04Ah,0E1h,048h,0DCh,09Ch,060h,026h,08Ah,011h,0E1h,03Dh,06Ch,005h,0B1h,09Bh,071h,04Ah,0E1h,048h,0DCh,09Ch,060h>')
bMask          BYTE,DIM(36),OVER(sMask)
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?cmdRegister
      ThisWindow.Update()
      IF LEN(CLIP(RegistrationKey)) = 72
         LOOP i = 1 TO 36
            j = ((i-1) * 2) + 1
            CASE RegistrationKey[j]
              OF '0'
                 hiNibble = 0
              OF '1'
                 hiNibble = 1
              OF '2'
                 hiNibble = 2
              OF '3'
                 hiNibble = 3
              OF '4'
                 hiNibble = 4
              OF '5'
                 hiNibble = 5
              OF '6'
                 hiNibble = 6
              OF '7'
                 hiNibble = 7
              OF '8'
                 hiNibble = 8
              OF '9'
                 hiNibble = 9
              OF 'A'
                 hiNibble = 10
              OF 'B'
                 hiNibble = 11
              OF 'C'
                 hiNibble = 12
              OF 'D'
                 hiNibble = 13
              OF 'E'
                 hiNibble = 14
              OF 'F'
                 hiNibble = 15
            END
            CASE RegistrationKey[j+1]
              OF '0'
                 loNibble = 0
              OF '1'
                 loNibble = 1
              OF '2'
                 loNibble = 2
              OF '3'
                 loNibble = 3
              OF '4'
                 loNibble = 4
              OF '5'
                 loNibble = 5
              OF '6'
                 loNibble = 6
              OF '7'
                 loNibble = 7
              OF '8'
                 loNibble = 8
              OF '9'
                 loNibble = 9
              OF 'A'
                 loNibble = 10
              OF 'B'
                 loNibble = 11
              OF 'C'
                 loNibble = 12
              OF 'D'
                 loNibble = 13
              OF 'E'
                 loNibble = 14
              OF 'F'
                 loNibble = 15
            END
            bLicense[i] = BOR(BSHIFT(hiNibble,4),loNibble)
         END
      
         RetVal = kcr_RegOpenKeyEx(HKEY_CURRENT_USER,szSubKey,0,KEY_SET_VALUE,hDevuna)
         IF RetVal = ERROR_SUCCESS
            RetVal = kcr_RegSetValueEx(hDevuna,szValueName,0,REG_BINARY,ADDRESS(BinaryLicense),SIZE(BinaryLicense))
            IF RetVal = ERROR_SUCCESS
               ReturnCode = Level:Benign
            ELSE
               szErrorFunc = 'RegSetValueEx'
               DO HandleError
            END
            RetVal = kcr_RegCloseKey(hDevuna)
         ELSE
            szErrorFunc = 'RegOpenKeyEx'
            DO HandleError
         END
      
      ELSE
      END
      POST(EVENT:CloseWindow)
    OF ?CancelButton
      ThisWindow.Update()
      POST(EVENT:CloseWindow)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
  If event() = event:VisibleOnDesktop !or event() = event:moved
    ds_VisibleOnDesktop()
  end
     IF KEYCODE()=CtrlShiftP AND EVENT() = Event:PreAlertKey
       CYCLE
     END
     IF KEYCODE()=CtrlShiftP  
    
       CYCLE
     END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE EVENT()
    OF EVENT:CloseDown
      if WE::CantCloseNow
        WE::MustClose = 1
        cycle
      else
        self.CancelAction = cancel:cancel
        self.response = requestcancelled
      end
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:OpenWindow
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

