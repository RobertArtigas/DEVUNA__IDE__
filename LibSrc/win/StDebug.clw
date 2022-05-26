                              MEMBER
!==============================================================================
!If all fields begin with the same prefix, then you can have that auto-stripped
!by uncommenting the following line.
!E_StripPrefix         EQUATE(1)
!==============================================================================
WidthMultiplier:Narrow        EQUATE(5)  !normal columns (numbers, lowercase, etc.)
WidthMultiplier:Wide          EQUATE(7)  !uppercase columns
!==============================================================================
                              MAP
  SECTION('STDebug Prototypes')
ST::Debug                       PROCEDURE(STRING DebugString),NAME('$ST::Debug')
ST::DebugString                 PROCEDURE(STRING DebugString),NAME('$ST::DebugString')
ST::DebugRecord                 PROCEDURE(*FILE pFile,STRING pMsg),NAME('$ST::DebugRecord1')
ST::DebugRecord                 PROCEDURE(*FILE pFile1,*FILE pFile2,STRING pMsg),NAME('$ST::DebugRecord2')
ST::DebugGroup                  PROCEDURE(*GROUP pGroup,STRING pMsg,<STRING pStructureType>)
ST::DebugGroup                  PROCEDURE(*GROUP pGroup,<*GROUP pGroup2>,STRING pMsg,<STRING pStructureType>)
ST::DebugQueue                  PROCEDURE(*QUEUE pQueue,<STRING pMsg>,<BYTE pNoTouch>),NAME('$ST::DebugQueue')
ST::DebugEventName              PROCEDURE(<LONG EventNum>),STRING,NAME('$ST::DebugEventName')
ST::DebugBreak                  PROCEDURE,NAME('$ST::DebugBreak')
ST::DebugClear                  PROCEDURE,NAME('$ST::DebugClear')
ST::GenerateFillQueueCode       PROCEDURE(*QUEUE pQueue,STRING pQueueName,<BOOL StripPrefix>),NAME('ST::GenerateFillQueueCode'),STRING
ST::Log                         PROCEDURE(STRING Msg),NAME('$ST::Log')
  SECTION('STDebug Prototypes END')

FormatMessageList               PROCEDURE(STRING pMsg,*QUEUE pMsgQueue)
GetQueueFieldCount              PROCEDURE(*QUEUE pQueue),LONG

                                MODULE('')
ExternalOutputDebugString         PROCEDURE(*CSTRING),RAW,PASCAL,NAME('OutputDebugStringA')
ExternalDebugBreak                PROCEDURE,NAME('DebugBreak')
                                END
                                MODULE('C%V%RUN%X%')
ST::Debug:NameMessage             PROCEDURE(*CSTRING,UNSIGNED EventNum),RAW,NAME('WslDebug$NameMessage')
ST::Debug:GetFieldName            PROCEDURE(SIGNED FEQ),*CSTRING,RAW,NAME('Clas$FIELDNAME')
                                END
                              END
!==============================================================================
  INCLUDE('STDebug.equ'),ONCE  !Debugging Flags
  INCLUDE('STDebug.cli'),ONCE  !Class Definitions
  INCLUDE('Errors.clw' ),ONCE  !Error Equates
!==============================================================================
ST::Debug                     PROCEDURE(STRING DebugString)  !MH 03/01/05 #IMDD
!--------------------------------------
DB                              CSTRING(500)
Stepping                        BYTE,AUTO
Step                            LONG,DIM(2)
!--------------------------------------
  CODE
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  DB = ST::DEBUG:PREFIX & CLIP(DebugString) & '<13,10,0>'
  ExternalOutputDebugString(DB)
  !---
  !Stepping = GETINI('Debug', 'Stepping',, 'STDEBUG.INI')
  !IF Stepping
  !  Step[1] = GETINI('Debug', 'Step',, 'STDEBUG.INI')
  !  LOOP
  !    Step[2] = GETINI('Debug', 'Step',, 'STDEBUG.INI')
  !  UNTIL Step[2] <> Step[1]
  !END
  !ENDCOMPILE
  
!==============================================================================
ST::DebugString               PROCEDURE(STRING DebugString)
!--------------------------------------
DB                              &CSTRING
L                               ULONG,AUTO
X                               ULONG,AUTO
Stepping                        BYTE,AUTO
Step                            LONG,DIM(2)
!--------------------------------------
  CODE
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  L = LEN(DebugString) + LEN(ST::DEBUG:PREFIX) + 20
  DB &= NEW CSTRING(L*5)
  DB  = ST::DEBUG:PREFIX |
      &'Len='& L |
      &',Val='& QUOTE(DebugString, 0) |
      &'<13,10,0>'
  ExternalOutputDebugString(DB)
  DISPOSE(DB)
  !---
  !Stepping = GETINI('Debug', 'Stepping',, 'STDEBUG.INI')
  !IF Stepping
  !  Step[1] = GETINI('Debug', 'Step',, 'STDEBUG.INI')
  !  LOOP
  !    Step[2] = GETINI('Debug', 'Step',, 'STDEBUG.INI')
  !  UNTIL Step[2] <> Step[1]
  !END
  !ENDCOMPILE
  
!==============================================================================
ST::DebugRecord               PROCEDURE(*FILE pFile,STRING pMsg)
!--------------------------------------
G                               &GROUP
!--------------------------------------
  CODE
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  G &= pFile{PROP:Record}
  ST::DebugGroup(G,, pMsg, 'Record')
  !ENDCOMPILE

!==============================================================================
ST::DebugRecord               PROCEDURE(*FILE pFile,*FILE pFile2,STRING pMsg)
!--------------------------------------
G1                              &GROUP
G2                              &GROUP
!--------------------------------------
  CODE
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  G1 &= pFile{PROP:Record}
  G2 &= pFile2{PROP:Record}
  ST::DebugGroup(G1, G2, pMsg, 'Record')
  !ENDCOMPILE

!==============================================================================
ST::DebugGroup                PROCEDURE(*GROUP pGroup,STRING pMsg,<STRING pStructureType>)
!--------------------------------------
  CODE
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  ST::DebugGroup(pGroup,, pMsg)
  !ENDCOMPILE

!==============================================================================
ST::DebugGroup                PROCEDURE(*GROUP pGroup,<*GROUP pGroup2>,STRING pMsg,<STRING pStructureType>)
!--------------------------------------
epGroup2                        EQUATE(2)
SavePointer                     LONG,AUTO
NumFields                       SHORT(0)
NumFields2                      SHORT(0)
FieldQ                          QUEUE
Name                              CSTRING(100)
Value                             CSTRING(1000)
Value2                            CSTRING(1000)
                                END
MsgLineQ                        QUEUE
Text                              STRING(100)
                                END
!--------------------------------------
Window                          WINDOW('Debug'),AT(,,676,416),FONT('Tahoma',8,,),CENTER,SYSTEM,GRAY,DOUBLE
                                  LIST,AT(4,4,668,356),USE(?DebugList),VSCROLL,FORMAT('125L(2)|M~Field Name~S(1)@S100@180L(2)|M~Value~S(1)@S255@1000L(2)|M~Value2~S(1)@' &|
                                      'S255@'),FROM(FieldQ)
                                  LIST,AT(4,364,668,48),USE(?MessageList),VSCROLL,FROM(MsgLineQ)
                                END
!--------------------------------------
  CODE
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  DO LoadFieldQ
  !--- Prepare window
  OPEN(Window)
  IF OMITTED(epGroup2)
    ?DebugList{PROPLIST:Width, 2} = 1000
  END
  0{PROP:Text} = 0{PROP:Text} &' '& CHOOSE(pStructureType='', 'Group', pStructureType) &' ('& NumFields &' Fields)'
  IF pMsg
    FormatMessageList(pMsg, MsgLineQ)
  ELSE
    HIDE(?MessageList)
    ?DebugList{PROP:Height} = ?DebugList{PROP:Height} + ?MessageList{PROP:Height} + 4
  END
  !--- Display window
  ACCEPT
  END
  !ENDCOMPILE

!======================================
LoadFieldQ                    ROUTINE
!--------------------------------------
  DATA
F   ANY                  !Field reference for value assignment
X   SHORT,AUTO
M   SHORT(0)
!--------------------------------------
  CODE
  OMIT('!+++!!!+++!')
  LOOP X = 10000 TO 1 BY -1
    IF NumFields = 0 AND WHO(pGroup, X) <> ''
      NumFields = X
      IF M = 0
        M = NumFields
      END
    END
    IF NOT OMITTED(epGroup2)  |
        AND NumFields2 = 0 AND WHO(pGroup2, X) <> ''
      NumFields2 = X
      IF M = 0
        M = NumFields2
      END
    END
    IF M = 0 AND (NumFields OR NumFields2)
      M = X
    END
    IF NumFields AND (OMITTED(epGroup2) OR NumFields2)
      BREAK
    END
  END
  LOOP X = 1 TO M
    CLEAR(FieldQ)
    IF NumFields >= X
      FieldQ.Name   = WHO(pGroup, X)
      F            &= WHAT(pGroup, X, 1)
      FieldQ.Value  = F
      IF NumFields2 >= X
        DO AssignValue2
      END
    ELSE
      FieldQ.Name   = WHO(pGroup2, X)
      DO AssignValue2
    END
    ADD(FieldQ)
    ASSERT(ERRORCODE()=0)
  END
  !+++!!!+++!

!======================================
AssignValue2                  ROUTINE
!--------------------------------------
  OMIT('!+++!!!+++!')
  F            &= WHAT(pGroup2, X, 1)
  FieldQ.Value2 = F
  !+++!!!+++!

!==============================================================================
ST::DebugQueue                PROCEDURE(*QUEUE pQueue,<STRING pMsg>,<BYTE pNoTouch>)
                              MAP
LoadFieldQ                      PROCEDURE
                              END
!--------------------------------------
SavePointer                     LONG,AUTO
NumFields                       SHORT,AUTO
                                COMPILE('***---***', E_StripPrefix)
!StripPrefixLength   BYTE,AUTO
                                ***---***
FieldQ                          QUEUE
Header                            CSTRING(100)
Width                             LONG
IsNumeric                         BOOL
IsGroup                           BOOL
                                END
MsgLineQ                        QUEUE
Text                              STRING(1000)
                                END    
!--------------------------------------
Window                          WINDOW('Debug Queue'),SYSTEM,AT(,,676,416),CENTER,FONT('Tahoma', 8),GRAY,DOUBLE
                                  LIST, AT(4,4,668,356), USE(?DebugList), HVSCROLL
                                  LIST, AT(4,364,668,48), USE(?MessageList), VSCROLL, FROM(MsgLineQ)
                                END
!--------------------------------------
  CODE
  !ST::Debug('ST::DebugQueue/IN')
  COMPILE('!ENDCOMPILE', ST::DEBUG:Debugging=1)
  IF pQueue &= NULL
    MESSAGE('Queue passed to ST::DebugQueue was a NULL pointer!', 'Debug Queue')
  ELSE
    !--- Save current queue pointer
    SavePointer = CHOOSE(RECORDS(pQueue)=0, 0, POINTER(pQueue))
    !--- Scan passed queue
    NumFields = GetQueueFieldCount(pQueue)
    IF NumFields = 0
      MESSAGE('Queue passed to ST::DebugQueue has no fields!', 'Debug Queue')
    ELSE
      COMPILE('***---***', E_StripPrefix)
      DO CheckStripPrefix
      ***---***
      LoadFieldQ
      !--- Prepare window
      OPEN(Window)
      0{PROP:Text} = 0{PROP:Text} &' ('& NumFields &' Fields, '& RECORDS(pQueue) &' Records)'
      DO FormatFieldList
      IF pMsg
        FormatMessageList(pMsg, MsgLineQ)
      ELSE
        HIDE(?MessageList)
        ?DebugList{PROP:Height} = ?DebugList{PROP:Height} + ?MessageList{PROP:Height} + 4
      END
      !--- Display window
      ACCEPT
      END
      !--- Restore queue pointer
      IF SavePointer <> 0 AND pNoTouch <> 1
        GET(pQueue, SavePointer)
      END
    END
  END
  !ENDCOMPILE
  !ST::Debug('ST::DebugQueue/OUT')

!**************************************
  COMPILE('***---***', E_StripPrefix)
!======================================
CheckStripPrefix              ROUTINE
!--------------------------------------
  DATA
FieldNo SHORT,AUTO
PrefixFound CSTRING(20)
!--------------------------------------
  CODE
  LOOP FieldNo = 1 TO NumFields
    FieldQ.Header = WHO(pQueue, FieldNo)
    StripPrefixLength = INSTRING(':', FieldQ.Header)
    IF StripPrefixLength
      IF FieldNo = 1
        PrefixFound = FieldQ.Header[1:S]
      ELSIF FieldQ.Header[1:S] <> PrefixFound
        StripPrefixLength = 0
        BREAK
      END
    ELSIF PrefixFound
      StripPrefixLength = 0
      BREAK
    END
  END

  ***---***
!======================================
FormatFieldList               ROUTINE
!--------------------------------------
  DATA
FieldNo SHORT,AUTO
ColumnNo    SHORT(0)
!--------------------------------------
  CODE
  ?DebugList{PROP:From} = pQueue
  ?DebugList{PROP:Selected} = SavePointer
  LOOP FieldNo = 1 TO NumFields
    GET(FieldQ, FieldNo)
    IF FieldQ.IsGroup
      CYCLE
    END
    ColumnNo += 1
    ?DebugList{PROPLIST:Header                    , ColumnNo} = FieldQ.Header
    ?DebugList{PROPLIST:Picture                   , ColumnNo} = '@S'& FieldQ.Width
    ?DebugList{PROPLIST:RightBorder               , ColumnNo} = 1
    ?DebugList{PROPLIST:Resize                    , ColumnNo} = 1
    ?DebugList{PROPLIST:Width                     , ColumnNo} = FieldQ.Width
    ?DebugList{PROPLIST:HeaderCenter              , ColumnNo} = True
!   ?DebugList{PROPLIST:HeaderLeft                , ColumnNo} = True
!   ?DebugList{PROPLIST:HeaderLeftOffset          , ColumnNo} = 1
    IF FieldQ.IsNumeric
      ?DebugList{PROPLIST:Right                   , ColumnNo} = True
      ?DebugList{PROPLIST:RightOffset             , ColumnNo} = 1
    ELSE
      ?DebugList{PROPLIST:Left                    , ColumnNo} = True
      ?DebugList{PROPLIST:LeftOffset              , ColumnNo} = 1
    END
    ?DebugList{PROPLIST:FieldNo                   , ColumnNo} = FieldNo
  END
  !ST::Debug(?DebugList{PROP:Format})

!**************************************
!======================================
LoadFieldQ                    PROCEDURE
!--------------------------------------
NamePipe                        SHORT,AUTO !RAYS
FieldNo                         SHORT,AUTO
FieldRef                        ANY
RecNo                           LONG,AUTO
SampleLength                    LONG,AUTO
HeaderLength                    LONG,AUTO
DataLength                      LONG,AUTO
IsDataUpper                     BOOL,AUTO
!--------------------------------------
  CODE
  !ST::Debug('ST::DebugQueue/LoadFieldQ/IN: NumFields='& NumFields)
  LOOP FieldNo = 1 TO NumFields
    CLEAR(FieldQ)
    !ST::Debug('ST::DebugQueue/LoadFieldQ: FieldNo='& FieldNo)
    FieldQ.Header                  = LOWER(WHO(pQueue, FieldNo))

	!NamePipe = INSTRING('|', FieldQ.Header) !RAYS
	!IF NamePipe THEN FieldQ.Header[NamePipe] = '<0>' END !RAYS

    COMPILE('***---***', E_StripPrefix)
    IF StripPrefixLength
      HeaderLength                 = LEN(FieldQ.Header) - StripPrefixLength
      FieldQ.Header                = SUB(FieldQ.Header, StripPrefixLength+1, HeaderLength)
    ELSE
      ***---***
      HeaderLength                 = LEN(FieldQ.Header)
      COMPILE('***---***', E_StripPrefix)
    END
    ***---***
    IF HeaderLength < 1
      HeaderLength                 = 1
    END
    FieldRef                      &= WHAT(pQueue, FieldNo, 1)
    FieldQ.IsGroup                 = ISGROUP(pQueue, FieldNo)
    FieldQ.IsNumeric               = TRUE
    IsDataUpper                    = FALSE
    !ST::Debug('ST::DebugQueue/LoadFieldQ: RECORDS(pQueue)='& RECORDS(pQueue))
    IF RECORDS(pQueue) > 0 AND pNoTouch <> 1
      DataLength                   = 0
      LOOP RecNo = 1 TO RECORDS(pQueue)
        GET(pQueue, RecNo)
        !ST::Debug('ST::DebugQueue/LoadFieldQ: RecNo='& RecNo &'; FieldRef='& FieldRef)
        IF FieldRef <> ''
          IF NOT NUMERIC(FieldRef)
            FieldQ.IsNumeric       = FALSE
          END
          SampleLength = LEN(CLIP(FieldRef))
          IF NOT FieldQ.IsNumeric AND UPPER(FieldRef) = FieldRef
            IsDataUpper            = TRUE
          END
          IF SampleLength > 25
            DataLength             = 25
          ELSIF DataLength < SampleLength
            DataLength             = SampleLength
          END
        END
      END
    ELSE
      IsDataUpper                  = TRUE
      FieldQ.IsNumeric             = FALSE
      DataLength                   = LEN(FieldRef)
    END
    DO CalculateColumnWidth
    ADD(FieldQ)
  END  
  !ST::Debug('ST::DebugQueue/LoadFieldQ/OUT')

CalculateColumnWidth          ROUTINE
  DATA
HeaderWidth SHORT,AUTO
DataWidth   SHORT,AUTO
  CODE
  HeaderWidth  = HeaderLength * WidthMultiplier:Narrow
  DataWidth    = DataLength * CHOOSE(~IsDataUpper, WidthMultiplier:Narrow, WidthMultiplier:Wide)
  FieldQ.Width = CHOOSE(DataWidth > HeaderWidth, DataWidth, HeaderWidth) + 2
  !ST::Debug(FieldQ.Header &' - '& HeaderLength &' - '& DataLength &' - '& HeaderWidth &' - '& DataWidth &' - '& FieldQ.Width)

!==============================================================================
FormatMessageList             PROCEDURE(STRING pMsg,*QUEUE pMsgQueue)
!--------------------------------------
StartPos                        LONG(1)
Pos                             LONG,AUTO
!--------------------------------------
  CODE
  IF pMsg
    LOOP WHILE StartPos
      Pos = INSTRING('|', pMsg, 1, StartPos)
      pMsgQueue = CHOOSE(Pos=0, pMsg[StartPos : LEN(pMsg)], pMsg[StartPos : Pos-1])
      ADD(pMsgQueue)
      ASSERT(ERRORCODE()=0)
      StartPos = Pos+1
    UNTIL Pos = 0
  END

!==============================================================================
!==============================================================================
ST::DebugEventsClass.Construct    PROCEDURE
  CODE
  SELF.ControlQ     &= NEW ST::DebugControlQueue
  SELF.EventQ       &= NEW ST::DebugEventQueue
  SELF.IgnoreEventQ &= NEW ST::DebugEventQueue
  SELF.SetPurgeTime(5*60*100)  !5 minutes

ST::DebugEventsClass.Destruct PROCEDURE
  CODE
  FREE(SELF.ControlQ)
  DISPOSE(SELF.ControlQ)

  FREE(SELF.EventQ)
  DISPOSE(SELF.EventQ)

  FREE(SELF.IgnoreEventQ)
  DISPOSE(SELF.IgnoreEventQ)

ST::DebugEventsClass.SetDebugEvent    PROCEDURE(SIGNED Event)
  CODE
  SELF.DebugEvent = Event

ST::DebugEventsClass.SetHotKey    PROCEDURE(UNSIGNED HotKey)
  CODE
  0{PROP:Alrt, 255} = HotKey
  SELF.HotKey = HotKey
  SELF.SetDebugEvent(EVENT:AlertKey)

ST::DebugEventsClass.SetPurgeTime PROCEDURE(LONG PurgeTime)
  CODE
  IF PurgeTime <= 0
    SELF.PurgeStarTime = 0
  ELSE
    SELF.PurgeStarTime = SELF.CalcStarDate(0, PurgeTime)
  END

ST::DebugEventsClass.AddControl   PROCEDURE(SIGNED Feq,STRING Name)
  CODE
  SELF.ControlQ.Feq  = Feq
  SELF.ControlQ.Name = Name
  ADD(SELF.ControlQ, SELF.ControlQ.Feq)

ST::DebugEventsClass.IgnoreEvent  PROCEDURE(SIGNED Event)
X                                   LONG,AUTO
  CODE
  CLEAR(SELF.IgnoreEventQ)
  SELF.IgnoreEventQ.EventNo = Event
  ADD(SELF.IgnoreEventQ, SELF.IgnoreEventQ.EventNo)

  ! Purge existing logged events
  LOOP X = RECORDS(SELF.EventQ) TO 1 BY -1
    GET(SELF.EventQ, X)
    IF SELF.EventQ.EventNo = Event
      DELETE(SELF.EventQ)
    END
  END

ST::DebugEventsClass.GetControlName   PROCEDURE(SIGNED Feq)!,STRING
  CODE
  IF Feq
    SELF.ControlQ.Feq = Feq
    GET(SELF.ControlQ, SELF.ControlQ.Feq)
    IF ERRORCODE() = 0
      RETURN SELF.ControlQ.Name
    END
  END
  RETURN ''

ST::DebugEventsClass.TakeEvent    PROCEDURE
  CODE
  !ST::Debug('ST::DebugEventsClass.TakeEvent: DebugEvent='& SELF.DebugEvent &'; Event='& EVENT() &'-'& SELF.GetEventName(EVENT()) &'; Keycode='& KEYCODE())
  CASE EVENT()
  OF 0
  OROF EVENT:Suspend
  OROF EVENT:Resume
    !ST::Debug('...Ignore It')
    !Ignore it
  OF SELF.DebugEvent
    !ST::Debug('...Debug Event  '& SELF.DebugEvent &'/'& EVENT:AlertKey &'  ' & KEYCODE() &'/'& SELF.HotKey)
    IF SELF.DebugEvent <> EVENT:AlertKey |
        OR KEYCODE() = SELF.HotKey
      SELF.Debug
    ELSE
      SELF.LogEvent
    END
  ELSE
     !ST::Debug('...Logger')
    IF SELF.DebugEvent <> EVENT:AlertKey     |
        OR EVENT()         <> EVENT:PreAlertKey  |
        OR KEYCODE()       <> SELF.HotKey
      SELF.LogEvent
    END
  END

ST::DebugEventsClass.LogEvent PROCEDURE
  CODE
  SELF.IgnoreEventQ.EventNo = EVENT()
  GET(SELF.IgnoreEventQ, SELF.IgnoreEventQ.EventNo)
  IF ERRORCODE() <> 0
    CLEAR(SELF.EventQ)
    SELF.EventQ.Date      = FORMAT(TODAY(), @D10)
    SELF.EventQ.Time      = FORMAT(CLOCK(), @T6)
    SELF.EventQ.StarDate  = SELF.CalcStarDate()
    SELF.EventQ.EventNo   = EVENT()
    SELF.EventQ.EventName = SELF.GetEventName(EVENT())
    SELF.EventQ.FieldFeq  = FIELD()
    SELF.EventQ.FieldName = SELF.GetControlName(FIELD())
    SELF.EventQ.Keycode   = KEYCODE()
    ADD(SELF.EventQ, SELF.EventQ.StarDate)
  END
  ! Purge old events
  LOOP WHILE SELF.PurgeStarTime <> 0 AND RECORDS(SELF.EventQ)
    GET(SELF.EventQ, 1)
    IF SELF.EventQ.StarDate > SELF.CalcStarDate() - SELF.PurgeStarTime THEN BREAK.
    DELETE(SELF.EventQ)
  END

ST::DebugEventsClass.Debug    PROCEDURE
  CODE
  !ST::DebugQueue(SELF.EventQ)

ST::DebugEventsClass.CalcStarDate PROCEDURE(<LONG D>,<LONG T>)!,REAL
  CODE
  IF OMITTED(D) THEN D = TODAY().
  IF OMITTED(T) THEN T = CLOCK().
  RETURN D + (T-1)/8640000

ST::DebugEventsClass.GetEventName PROCEDURE(SIGNED Event)!,STRING
  CODE
  CASE Event

    ! Field-dependent events

  OF 01H;  RETURN 'Accepted'
  OF 02H;  RETURN 'NewSelection'
  OF 02H;  RETURN 'ScrollUp'
  OF 04H;  RETURN 'ScrollDown'
  OF 05H;  RETURN 'PageUp'
  OF 06H;  RETURN 'PageDown'
  OF 07H;  RETURN 'ScrollTop'
  OF 08H;  RETURN 'ScrollBottom'
  OF 09H;  RETURN 'Locate'

  OF 01H;  RETURN 'MouseDown'
  OF 0aH;  RETURN 'MouseUp'
  OF 0bH;  RETURN 'MouseIn'
  OF 0cH;  RETURN 'MouseOut'
  OF 0dH;  RETURN 'MouseMove'
  OF 0eH;  RETURN 'VBXevent'
  OF 0fH;  RETURN 'AlertKey'
  OF 10H;  RETURN 'PreAlertKey'
  OF 11H;  RETURN 'Dragging'
  OF 12H;  RETURN 'Drag'
  OF 13H;  RETURN 'Drop'
  OF 14H;  RETURN 'ScrollDrag'
  OF 15H;  RETURN 'TabChanging'
  OF 16H;  RETURN 'Expanding'
  OF 17H;  RETURN 'Contracting'
  OF 18H;  RETURN 'Expanded'
  OF 19H;  RETURN 'Contracted'
  OF 1AH;  RETURN 'Rejected'
  OF 1BH;  RETURN 'DroppingDown'
  OF 1CH;  RETURN 'DroppedDown'
  OF 1DH;  RETURN 'ScrollTrack'
  OF 1EH;  RETURN 'ColumnResize'

  OF 101H;  RETURN 'Selected'
  OF 102H;  RETURN 'Selecting'

    ! Field-independent events (FIELD() returns 0)

  OF 201H;  RETURN 'CloseWindow'
  OF 202H;  RETURN 'CloseDown'
  OF 203H;  RETURN 'OpenWindow'
  OF 204H;  RETURN 'OpenFailed'
  OF 205H;  RETURN 'LoseFocus'
  OF 206H;  RETURN 'GainFocus'

  OF 208H;  RETURN 'Suspend'
  OF 209H;  RETURN 'Resume'
  OF 20AH;  RETURN 'Notify'

  OF 20BH;  RETURN 'Timer'
  OF 20CH;  RETURN 'DDErequest'
  OF 20DH;  RETURN 'DDEadvise'
  OF 20EH;  RETURN 'DDEdata'
  OF 20FH;  RETURN 'DDEexecute'
  OF 210H;  RETURN 'DDEpoke'
  OF 211H;  RETURN 'DDEclosed'

  OF 220H;  RETURN 'Move'
  OF 221H;  RETURN 'Size'
  OF 222H;  RETURN 'Restore'
  OF 223H;  RETURN 'Maximize'
  OF 224H;  RETURN 'Iconize'
  OF 225H;  RETURN 'Completed'
  OF 230H;  RETURN 'Moved'
  OF 231H;  RETURN 'Sized'
  OF 232H;  RETURN 'Restored'
  OF 233H;  RETURN 'Maximized'
  OF 234H;  RETURN 'Iconized'
  OF 235H;  RETURN 'Docked'
  OF 236H;  RETURN 'Undocked'

  OF 240H;  RETURN 'BuildFile'
  OF 241H;  RETURN 'BuildKey'
  OF 242H;  RETURN 'BuildDone'

    ! User-definable events

  OF 3FFH;  RETURN 'DoResize'
  OF 400H;  RETURN 'User'
  END
  RETURN '???'

!==============================================================================
ST::DebugBreak                PROCEDURE
  CODE
  ExternalDebugBreak

!==============================================================================
ST::DebugClear                PROCEDURE
DB CSTRING('DBGVIEWCLEAR')
  CODE
  ExternalOutputDebugString(DB)

!==============================================================================
ST::Log                       PROCEDURE(STRING Msg)
                                OMIT('=== DO LINK', lib_mode)
  PRAGMA ('link (C%V%ASC%X%%L%.LIB)')
                                ! === DO LINK
LogFile                         FILE,DRIVER('ASCII'),PRE(Log),NAME('Debug.log'),CREATE
Record                            RECORD
Date                                STRING(11)
Time                                STRING(13)
Msg                                 STRING(250)
                                  END
                                END
  CODE
  LOOP 2 TIMES
    OPEN(LogFile)
    CASE ERRORCODE()
    OF NoError
      C# = CLOCK()
      LogFile.Date = FORMAT(TODAY(), @D10)
      LogFile.Time = FORMAT(C#, @T4) &'.'& FORMAT(C#%100, @N02)
      LogFile.Msg  = Msg
      ADD(LogFile)
      CLOSE(LogFile)
      ST::Debug('[LOG] '& Msg)
      BREAK
    OF NoFileErr
      CREATE(LogFile)
      IF ERRORCODE() <> NoError
        ST::Debug('[LOG] Cannot create Debug.log. Error '& ERRORCODE() &'-'& ERROR())
        BREAK
      END
    ELSE
      ST::Debug('[LOG] Cannot open Debug.log. Error '& ERRORCODE() &'-'& ERROR())
      BREAK
    END
  END

!==============================================================================
ST::DebugEventName            PROCEDURE(<LONG EventNum>)!,STRING
EVENT:APP                       EQUATE(08000h)
EVENT:APP_LAST                  EQUATE(0AFFFh)
!EVENT:APP_LAST                 EQUATE(0BFFFh)  !SV seems to use 0B000h + N

                                COMPILE('_C6_PLUS_',_C60_)
EVENT:DebugOffset               EQUATE(0A000h)
                                !_C6_PLUS_
                                OMIT   ('_PRE_C6_',_C60_)
EVENT:DebugOffset               EQUATE(01400h)
                                !_PRE_C6_

EventName                       CSTRING(100)
  CODE
  IF OMITTED(EventNum)
    EventNum = EVENT()
  END
  CASE EventNum
  OF EVENT:DoResize               ;  EventName = 'DoResize'
  OF EVENT:User                   ;  EventName = 'User'
  OF EVENT:User+1 TO EVENT:Last   ;  EventName = 'User+'& EventNum - EVENT:User
  OF EVENT:App                    ;  EventName = 'App'
  OF EVENT:App+1 TO EVENT:App_Last;  EventName = 'App+' & EventNum - EVENT:App
  ELSE
    ST::Debug:NameMessage(EventName, EVENT() + EVENT:DebugOffset)
    IF UPPER(LEFT(EventName, 6)) = 'EVENT:'
      EventName = SUB(EventName, 7, LEN(EventName)-6)
    END
  END
  RETURN EventName

!==============================================================================
ST::GenerateFillQueueCode     PROCEDURE(*QUEUE pQueue,STRING pQueueName,<BOOL StripPrefix>)!,STRING
                              MAP
FieldName                       PROCEDURE,STRING
                              END
NumFields                       LONG,AUTO
X                               LONG,AUTO
FieldNo                         LONG,AUTO
FieldRef                        ANY
S                               CSTRING(30000)
SingleQuote                     CSTRING(2)
  CODE
  NumFields = GetQueueFieldCount(pQueue)
  IF NumFields > 0
    S = ' FREE('& pQueueName &')<13,10>'
    IF RECORDS(pQueue)
      LOOP X = 1 TO RECORDS(pQueue)
        GET(pQueue, X)
        S = S &' CLEAR('& pQueueName &');'
        LOOP FieldNo = 1 TO NumFields
          IF NOT ISGROUP(pQueue, FieldNo)
            FieldRef &= WHAT(pQueue, FieldNo, 1)
            IF FieldRef
              SingleQuote = CHOOSE(~NUMERIC(FieldRef), '<39>', '')
              S = S & FieldName() &'='& SingleQuote & CLIP(FieldRef) & SingleQuote &';'
            END
          END
        END
        S = S &'ADD('& pQueueName &')<13,10>'
      END
    END
  END
  RETURN S

FieldName                     PROCEDURE!,STRING
FieldName                       CSTRING(100),AUTO
P                               LONG,AUTO
  CODE
  FieldName = WHO(pQueue, FieldNo)
  P = INSTRING(':', FieldName, 1, 1)
  IF P > 0
    IF StripPrefix
      FieldName = pQueueName &'.'& FieldName[P+1 : LEN(FieldName)]
    END
  ELSE
    FieldName = pQueueName &'.'& FieldName
  END
  RETURN FieldName

!==============================================================================
GetQueueFieldCount            PROCEDURE(*QUEUE pQueue)!,LONG
NumFields                       LONG,AUTO
  CODE
  NumFields = 5000
  LOOP WHILE NumFields > 0  |
      AND   WHO(pQueue, NumFields) = ''
    NumFields -= 1
  END
  RETURN NumFields
  
!==============================================================================
