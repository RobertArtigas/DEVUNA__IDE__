                              MEMBER

! RA.2022.07.17: Need to handle extended name attribute name (and sorting)

  INCLUDE('mhList.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Errors.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

ASCENDING                     EQUATE(1)
DESCENDING                    EQUATE(-1)

                              MAP
                                INCLUDE('STDebug.inc')
                              END

!==============================================================================
mhList.Construct              PROCEDURE
  CODE
  SELF.ColumnQueue      &= NEW mhList_ColumnQueue
  SELF.Locator          &= NEW mhList_Locator
  SELF.SortRetainsRecord = TRUE

!==============================================================================
mhList.Destruct               PROCEDURE
  CODE
  SELF.FreeColumnQueue()
  DISPOSE(SELF.Locator)
  DISPOSE(SELF.ColumnQueue)

!==============================================================================
!TODO: Doesn't retain yet
mhList.ApplySort              PROCEDURE
                              MAP
RetainingRecord                 PROCEDURE,BOOL
ComputeSortStringAndSetHeaders  PROCEDURE,STRING
                              END
SaveRecord                      STRING(SIZE(SELF.ListQueue)),AUTO
X                               LONG,AUTO
  CODE
  IF RetainingRecord()
    SELF.Fetch()
    SaveRecord = SELF.ListQueue
  END
  SORT(SELF.ListQueue, ComputeSortStringAndSetHeaders())
  IF RetainingRecord()
    LOOP X = 1 TO SELF.Records()
      IF SELF.Fetch(X) = Level:Benign |
          AND SELF.ListQueue = SaveRecord
        SELF.ListControl{PROP:Selected} = X
        BREAK
      END
    END
  END
  
RetainingRecord               PROCEDURE!,BOOL
  CODE
  RETURN CHOOSE(SELF.SortRetainsRecord AND CHOICE(SELF.ListControl) <> 0)

ComputeSortStringAndSetHeaders    PROCEDURE!,STRING
                              MAP
AppendSortField                 PROCEDURE(BYTE SortColumnIndex)
SetSortHeader                   PROCEDURE(BYTE SortColumnIndex)
                              END
N                                   BYTE,AUTO
SortString                          CSTRING(3000)
  CODE
  LOOP N = 1 TO SELF.SortColumns
    SELF.FetchColumnQueue(ABS(SELF.SortColumn[N]))
    AppendSortField(N)
    SetSortHeader(N)
  END
  ST::Debug('ComputeSortStringAndSetHeaders(): SortString=[ ' & CLIP(SortString) & ' ]')
  !STOP(SortString)
  RETURN SortString

AppendSortField               PROCEDURE(BYTE SortColumnIndex)
  CODE
  SortString = CHOOSE(SortColumnIndex=1, '', SortString & ',') |
      & CHOOSE(SELF.SortColumn[SortColumnIndex] > 0, '+', '-') |
      & SELF.ColumnQueue.FieldName
  
SetSortHeader                 PROCEDURE(BYTE SortColumnIndex)
SortDirectionPrefix             CSTRING(3),AUTO
SortDirectionSuffix             CSTRING(2),AUTO
SortNumberCharacter             CSTRING(2),AUTO
  CODE
  IF SELF.SortColumn[SortColumnIndex] > 0
    SortDirectionPrefix = '[+'
    SortDirectionSuffix = ']'
  ELSIF SELF.SortColumn[SortColumnIndex] < 0
    SortDirectionPrefix = '[-'
    SortDirectionSuffix = ']'
  ELSE
    SortDirectionPrefix = ''
    SortDirectionSuffix = ''
  END
  
  ST::Debug('SortColumns=[ '& SELF.SortColumns &' ]; SortColumnIndex=[ '& SortColumnIndex &' ]; SortColumn[ '& SortColumnIndex &' ]='& SELF.SortColumn[SortColumnIndex] &'')
  !STOP('SortColumns='& SELF.SortColumns &'; SortColumnIndex='& SortColumnIndex &'; SortColumn['& SortColumnIndex &']='& SELF.SortColumn[SortColumnIndex])


  IF SELF.SortColumns > 1
    SortNumberCharacter = SortColumnIndex
  ELSE
    SortNumberCharacter = ''
  END
  SELF.ListControl{PROPLIST:Header, ABS(SELF.SortColumn[SortColumnIndex])} = |
      SELF.ColumnQueue.Header & SortDirectionPrefix & SortNumberCharacter & SortDirectionSuffix

!==============================================================================
mhList.FetchColumnQueue       PROCEDURE(UNSIGNED ColumnID)!,BYTE
  CODE
  SELF.ColumnQueue.ID = ColumnID
  GET(SELF.ColumnQueue, SELF.ColumnQueue.ID)
  RETURN CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
  
!==============================================================================
mhList.FreeColumnQueue        PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.ColumnQueue)
    GET(SELF.ColumnQueue, 1)
    SELF.DeleteColumnQueue()
  END

!==============================================================================
mhList.DeleteColumnQueue      PROCEDURE
  CODE
  !Dispose any references within queue record
  SELF.ColumnQueue.FieldRef &= NULL
  DELETE(SELF.ColumnQueue)

!==============================================================================
mhList.Init                   PROCEDURE(SIGNED ListControl,*QUEUE ListQueue)
                              MAP
LoadColumns                     PROCEDURE
AlertKeys                       PROCEDURE
                              END
  CODE
  SELF.ListControl = ListControl
  SELF.ListQueue  &= ListQueue
  LoadColumns()
  AlertKeys()
  
LoadColumns                   PROCEDURE
ColumnID                        LONG
QueueFieldID                    LONG
ColumnCount                     LONG
NamePipe                        SHORT ! RAYS
  CODE
  ColumnCount = SELF.ListControl{PROPLIST:Exists, 0}
  IF ColumnCount > 0
    LOOP ColumnID = 1 TO ColumnCount
      CLEAR(SELF.ColumnQueue)
      QueueFieldID               = SELF.ListControl{PROPLIST:FieldNo, ColumnID}
      SELF.ColumnQueue.ID        = ColumnID
      SELF.ColumnQueue.FieldName = WHO(SELF.ListQueue, QueueFieldID)

	  !-----------------------------------------------------------!
      ! RAYS: ADDING THIS KILL THE SORT!!!! MORE DEBUG IS NEEDED. !
	  !-----------------------------------------------------------!
	  !NamePipe = INSTRING('|', SELF.ColumnQueue.FieldName) !RAYS
	  !IF NamePipe THEN SELF.ColumnQueue.FieldName[NamePipe] = '<0>' END !RAYS

      SELF.ColumnQueue.FieldRef &= WHAT(SELF.ListQueue, QueueFieldID)
      SELF.ColumnQueue.Header    = SELF.ListControl{PROPLIST:Header, ColumnID}
      ADD(SELF.ColumnQueue)
      
      IF SELF.ListControl{PROPLIST:Icon, ColumnID} OR SELF.ListControl{PROPLIST:IconTrn, ColumnID}
        QueueFieldID += 1;  SELF.ColumnQueue.IconRef       &= WHAT(SELF.ListQueue, QueueFieldID)
      END
      IF SELF.ListControl{PROPLIST:Style, ColumnID}
        QueueFieldID += 1;  SELF.ColumnQueue.StyleRef      &= WHAT(SELF.ListQueue, QueueFieldID)
      END
      IF SELF.ListControl{PROPLIST:Color, ColumnID}
        QueueFieldID += 1;  SELF.ColumnQueue.NormalFGRef   &= WHAT(SELF.ListQueue, QueueFieldID)
        QueueFieldID += 1;  SELF.ColumnQueue.NormalBGRef   &= WHAT(SELF.ListQueue, QueueFieldID)
        QueueFieldID += 1;  SELF.ColumnQueue.SelectedFGRef &= WHAT(SELF.ListQueue, QueueFieldID)
        QueueFieldID += 1;  SELF.ColumnQueue.SelectedBGRef &= WHAT(SELF.ListQueue, QueueFieldID)
      END
    END
  END
  !ST::DebugQueue(SELF.ColumnQueue)

AlertKeys                     PROCEDURE
K                               UNSIGNED,AUTO
  CODE
  SELF.ListControl{PROP:Alrt, 255} = MouseLeft
  SELF.ListControl{PROP:Alrt, 255} = CtrlMouseLeft
  
  LOOP K = Key0 TO Key9
    SELF.ListControl{PROP:Alrt,255} = K
  END
  LOOP K = AKey TO ZKey
    SELF.ListControl{PROP:Alrt,255} = K
  END
  SELF.ListControl  {PROP:Alrt,255} = BSKey
  SELF.ListControl  {PROP:Alrt,255} = SpaceKey
  
  
!==============================================================================
mhList.InitMarking            PROCEDURE(*? RealMarkField,<*? WinMarkField>)
  CODE
  SELF.RealMarkField &= RealMarkField
  IF OMITTED(WinMarkField)
    SELF.WinMarkField &= NULL
  ELSE
    SELF.WinMarkField &= WinMarkField
  END

!==============================================================================
mhList.InitTagging            PROCEDURE(LONG TaggingColumn,*? TaggingIconField,BYTE TaggedIconIndex,BYTE UntaggedIconIndex)
  CODE
  SELF.TaggingColumn     = TaggingColumn
  SELF.TaggingIconField &= TaggingIconField
  SELF.TaggedIconIndex   = TaggedIconIndex
  SELF.UntaggedIconIndex = UntaggedIconIndex

!==============================================================================
mhList.Fetch                  PROCEDURE(<UNSIGNED RowNum>)!,BYTE
  CODE
  IF RowNum
    GET(SELF.ListQueue, RowNum)
  ELSE
    GET(SELF.ListQueue, CHOICE(SELF.ListControl))
  END
  RETURN CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
  
!==============================================================================
mhList.IsMarked               PROCEDURE!,BOOL,VIRTUAL
  CODE
  IF NOT Self.RealMarkField &= NULL
    RETURN SELF.RealMarkField
  END
  RETURN FALSE

!==============================================================================
mhList.ListZone               PROCEDURE!,LONG
  CODE
  ST::Debug('mhList.ListZone: Focus='& FOCUS() &'; MouseDownZone='& SELF.ListControl{PROPLIST:MouseDownZone})
  IF SELF.ListControl{PROPLIST:MouseDownZone} AND FOCUS() = SELF.ListControl
    RETURN SELF.ListControl{PROPLIST:MouseDownZone}
  ELSE
    RETURN LISTZONE:NoWhere
  END
  
!==============================================================================
mhList.Load                   PROCEDURE
  CODE
  !Empty Virtual

!==============================================================================
mhList.Mark                   PROCEDURE(BYTE MarkValue)
  CODE
  IF POINTER(SELF.ListQueue) |
      AND NOT SELF.RealMarkField &= NULL
    SELF.RealMarkField = MarkValue
    IF NOT SELF.WinMarkField &= NULL
      SELF.WinMarkField = MarkValue
    END
    IF SELF.TaggingColumn <> 0
      SELF.TaggingIconField = CHOOSE(~MarkValue, SELF.UntaggedIconIndex, SELF.TaggedIconIndex)
    END
    PUT(SELF.ListQueue)
  END

!==============================================================================
mhList.Mark                   PROCEDURE
  CODE
  SELF.Mark(1)

!==============================================================================
mhList.Records                PROCEDURE!,UNSIGNED
  CODE
  RETURN RECORDS(SELF.ListQueue)

!==============================================================================
mhList.SetColumnHeader        PROCEDURE(LONG ColumnID,STRING Header)
  CODE
  IF SELF.FetchColumnQueue(ColumnID) = Level:Benign
    SELF.ColumnQueue.Header = Header
  END
 
!==============================================================================
mhList.SetQueueRecord         PROCEDURE
  CODE
  IF  NOT (SELF.TaggingIconField &= NULL OR SELF.RealMarkField &= NULL)
    SELF.TaggingIconField = CHOOSE(~SELF.RealMarkField, SELF.UntaggedIconIndex, SELF.TaggedIconIndex)
  END
  
!==============================================================================
mhList.TakeEvent              PROCEDURE!,BYTE
ReturnValue                     BYTE(Level:Benign)
  CODE
  IF FIELD() = SELF.ListControl
    CASE EVENT()
    OF EVENT:PreAlertKey
      CASE KEYCODE()
      OF   MouseLeft
      OROF CtrlMouseLeft
        IF SELF.ListZone() <> LISTZONE:Header
          ST::Debug('mhList.TakeEvent(): Cycle on Accept')
          ReturnValue = Level:Notify
        END
      END
    OF EVENT:AlertKey
      ST::Debug('mhList.TakeEvent(): EVENT:AlertKey: ListZone='& SELF.ListControl{PROPLIST:MouseDownZone} &'; MouseDownField='& SELF.ListControl{PROPLIST:MouseDownField})
      IF SELF.ListZone() = LISTZONE:Header
        ReturnValue = SELF.TakeSortEvent()
      END
      IF SELF.Locator.TakeKey() = Level:Notify
        DO HandleNewLocatorValue
      END
    OF EVENT:NewSelection
      ReturnValue = SELF.TakeNewSelection()
    OF EVENT:Selected
      ReturnValue = SELF.TakeSelected()
    OF EVENT:Accepted
      ReturnValue = SELF.TakeAccepted()
    END
    DO RefreshMarks
  END
  RETURN ReturnValue

HandleNewLocatorValue         ROUTINE
  DATA
X LONG,AUTO
L BYTE,AUTO
  CODE
  IF SELF.SortColumns > 0 AND SELF.Locator.GetValue() <> ''
    L = LEN(SELF.Locator.GetValue())
    SELF.FetchColumnQueue(SELF.SortColumn[1])
    LOOP X = 1 TO SELF.Records()
      GET(SELF.ListQueue, X)
      IF UPPER(LEFT(SELF.ColumnQueue.FieldRef, L)) = SELF.Locator.GetValue()
        SELF.ListControl{PROP:Selected} = X
        BREAK
      END
    END
  END

RefreshMarks                  ROUTINE
  DATA
X   LONG,AUTO
!NeedsRefresh BOOL(FALSE)
  CODE
  IF NOT SELF.WinMarkField &= NULL |
      AND SELF.Records() > 0
    LOOP X = 1 TO SELF.Records()
      SELF.Fetch(X)
      SELF.Mark(SELF.IsMarked())
!      IF SELF.IsMarked() <> SELF.WinMarkField
!        SELF.Mark(TRUE)
!        NeedsRefresh = TRUE
!      END
    END
!    IF NeedsRefresh
    SELF.Fetch(1)
    DELETE(SELF.ListQueue)
      ADD(SELF.ListQueue, 1)
!    END
  END
  
!==============================================================================
mhList.TakeNewSelection       PROCEDURE!,BYTE
  CODE
!  IF CHOICE(SELF.ListControl) = SELF.BC.CurrentChoice
!    RETURN PARENT.TakeNewSelection()
!  ELSE                                  ! Focus change to different record
!    SELF.TakeFocusLoss
!    IF SELF.Again
!      SELECT(SELF.ListControl,SELF.BC.CurrentChoice)
!      RETURN Level:Benign
!    ELSE
!      SELF.BC.CurrentChoice = CHOICE(SELF.ListControl)
!      SELF.Response = RequestCancelled           ! Avoid cursor following 'new' record
!      RETURN Level:Fatal
!    END
!  END
  SELF.Fetch()
  RETURN Level:Benign

!==============================================================================
mhList.TakeSelected           PROCEDURE!,BYTE
  CODE
  RETURN Level:Benign

!==============================================================================
mhList.TakeAccepted           PROCEDURE!,BYTE
ReturnValue                     BYTE(Level:Benign)
  CODE
  DO HandleIconClick
  DO HandleMarking
  RETURN ReturnValue

HandleIconClick               ROUTINE
  IF  KEYCODE()       = MouseLeft AND |
      SELF.ListZone() = LISTZONE:Icon
    SELF.Fetch()
    ReturnValue = SELF.TakeIconClick(SELF.ListControl{PROPLIST:MouseDownField})
    IF ReturnValue <> Level:Benign
      RETURN ReturnValue
    END
  END
  
HandleMarking                 ROUTINE
  DATA
X   LONG,AUTO
ShiftClickPos LONG,AUTO
  CODE
  IF NOT SELF.WinMarkField &= NULL
    CASE KEYCODE()
    OF MouseLeft
      DO MarkAnchor
    OF ShiftMouseLeft
      IF SELF.MarkAnchor
        ShiftClickPos = CHOICE(SELF.ListControl)
        LOOP X = 1 TO SELF.Records()
          SELF.Fetch(X)
          IF ShiftClickPos < SELF.MarkAnchor
            SELF.Mark(INRANGE(X, ShiftClickPos, SELF.MarkAnchor))
          ELSE
            SELF.Mark(INRANGE(X, SELF.MarkAnchor, ShiftClickPos))
          END
        END
      ELSE
        DO MarkAnchor
      END
    OF CtrlMouseLeft
      SELF.Fetch()
      SELF.Mark(CHOOSE(~SELF.IsMarked()))
    END
  END
  
MarkAnchor                    ROUTINE
  DATA
X   LONG,AUTO
  CODE
  SELF.MarkAnchor = CHOICE(SELF.ListControl)
  LOOP X = 1 TO SELF.Records()
    SELF.Fetch(X)
    IF X <> SELF.MarkAnchor
      SELF.Unmark()
    ELSE
      SELF.Mark()
    END
  END

!==============================================================================
mhList.TakeIconClick          PROCEDURE(UNSIGNED ColumnID)!,BYTE
  CODE
  IF ColumnID = SELF.TaggingColumn
    SELF.TaggingIconField = CHOOSE(SELF.TaggingIconField=SELF.UntaggedIconIndex, SELF.TaggedIconIndex, SELF.UntaggedIconIndex)
    PUT(SELF.ListQueue)
  END
  RETURN Level:Benign

!==============================================================================
mhList.TakeSortEvent          PROCEDURE!,BYTE
                              MAP
ToggleExistingSortColumn        PROCEDURE,BOOL
AppendSortColumn                PROCEDURE
                              END
ClickedColumn                   UNSIGNED,AUTO
  CODE
  ClickedColumn = SELF.ListControl{PROPLIST:MouseDownField}
  IF SELF.FetchColumnQueue(ClickedColumn) = Level:Benign
    CASE KEYCODE()
    OF MouseLeft
      SELF.SetPrimarySortColumn(ClickedColumn)
    OF CtrlMouseLeft
      IF NOT ToggleExistingSortColumn()
        AppendSortColumn()
      END
    END
	  !ST::Debug('mhList.TakeSortEvent(): SortString=[ ' & CLIP(SortString) & ' ]')
    !STOP(SortString)
    SELF.ApplySort()
  END
  RETURN Level:Benign
  
ToggleExistingSortColumn      PROCEDURE!,BOOL
AlreadySortedIndex              BYTE(0)
N                               BYTE,AUTO
  CODE
  LOOP N = 1 TO SELF.SortColumns
    IF ClickedColumn = ABS(SELF.SortColumn[N])
      SELF.SortColumn[N] = -SELF.SortColumn[N]
      RETURN TRUE
    END
  END
  RETURN FALSE

AppendSortColumn              PROCEDURE
SortColumnIndex            BYTE
  CODE
  IF SELF.SortColumns < MAXIMUM(SELF.SortColumn, 1)
    IF SELF.SortColumns >= 1 AND ABS(SELF.SortColumn[SELF.SortColumns]) = ClickedColumn
      IF SELF.SortColumn[SELF.SortColumns] = ClickedColumn
        SELF.SetSortColumn(ClickedColumn, SELF.SortColumns, DESCENDING)
      ELSE
        SELF.SetSortColumn(ClickedColumn, SELF.SortColumns, ASCENDING)
      END
    ELSE
      SELF.SetSortColumn(ClickedColumn, SELF.SortColumns+1, ASCENDING)
    END
  ELSE
    BEEP
  END

!==============================================================================
mhList.SetSort         PROCEDURE(UNSIGNED ClickedColumn)
  CODE
  SELF.SetPrimarySortColumn(ClickedColumn)
  SELF.ApplySort()

!==============================================================================
mhList.SetPrimarySortColumn   PROCEDURE(UNSIGNED ClickedColumn)
  CODE
  IF SELF.SortColumns >= 1 AND SELF.SortColumn[1] = ClickedColumn
    SELF.SetSortColumn(ClickedColumn, 1, DESCENDING)
  ELSE
    SELF.SetSortColumn(ClickedColumn, 1, ASCENDING)
  END

!==============================================================================
mhList.SetSortColumn          PROCEDURE(UNSIGNED ClickedColumn,BYTE SortColumnIndex, SHORT Direction)
                              MAP
ClearSorts                      PROCEDURE
                              END
  CODE
  SELF.SortColumns = SortColumnIndex
  ClearSorts()
  R# = SELF.FetchColumnQueue(ClickedColumn)
  ST::Debug('mhList.SetSortColumn('& R# &') - SELF.ColumnQueue.Header=[ '& CLIP(SELF.ColumnQueue.Header) &' ]')
  !STOP(R# &' - '& CLIP(SELF.ColumnQueue.Header))
  SELF.SortColumn[SortColumnIndex] = CHOOSE(Direction=ASCENDING, ClickedColumn, -ClickedColumn)

ClearSorts                    PROCEDURE
                              MAP
ResetColumnHeader               PROCEDURE
                              END
N                               BYTE,AUTO
  CODE
  LOOP N = SortColumnIndex TO MAXIMUM(SELF.SortColumn, 1)
    IF SELF.SortColumn[N] = 0
      BREAK
    END
    SELF.FetchColumnQueue(ABS(SELF.SortColumn[N]))
    IF N = SortColumnIndex
      IF ABS(SELF.SortColumn[N]) <> ClickedColumn
        ResetColumnHeader()
      END
    ELSE
      ResetColumnHeader()
      SELF.SortColumn[N] = 0
    END
  END

ResetColumnHeader             PROCEDURE
  CODE
  SELF.ListControl{PROPLIST:Header, ABS(SELF.SortColumn[N])} = SELF.ColumnQueue.Header

!==============================================================================
mhList.Unmark                 PROCEDURE
  CODE
  SELF.Mark(0)

!==============================================================================
!==============================================================================
mhList_Locator.GetValue       PROCEDURE!,STRING
  CODE
  RETURN SELF.Value

!==============================================================================
mhList_Locator.TakeKey        PROCEDURE!,BYTE
ReturnValue                     BYTE(Level:Benign)
  CODE
  CASE KEYCODE()
  OF BSKey                               !Locator
    SELF.CheckTimeout()
    SELF.RemoveCharacter()
    ReturnValue = Level:Notify
  OF SpaceKey
    SELF.CheckTimeout()
    SELF.AppendCharacter(' ')
    ReturnValue = Level:Notify
  ELSE
    IF KEYCHAR() <> 0
      SELF.CheckTimeout()
      SELF.AppendCharacter(UPPER(CHR(KEYCHAR())))
      ReturnValue = Level:Notify
    END
  END
  IF ReturnValue <> Level:Benign
    SELF.Display()
    SELF.LastKeyTime = CLOCK()
  END
  RETURN ReturnValue
  
!==============================================================================
mhList_Locator.AppendCharacter    PROCEDURE(STRING C)
  CODE
  SELF.Value = SELF.Value & C
  
!==============================================================================
mhList_Locator.Display                PROCEDURE
  CODE
  IF SELF.Control <> 0
    CASE SELF.Control{PROP:Type}
    OF CREATE:string !OROF CREATE:sstring
      SELF.Control{PROP:Text} = SELF.Value
    ELSE
      CHANGE(SELF.Control, SELF.Value)
    END
  END
  
!==============================================================================
mhList_Locator.RemoveCharacter    PROCEDURE
L                                   BYTE,AUTO
  CODE
  L = LEN(SELF.Value)
  IF L <= 1
    SELF.ClearValue()
  ELSE
    SELF.Value = SELF.Value[1 : L-1]
  END
  
!==============================================================================
mhList_Locator.ClearValue     PROCEDURE
  CODE
  SELF.Value = ''
  
!==============================================================================
mhList_Locator.CheckTimeout   PROCEDURE
TIMEOUT                         EQUATE(200)  !2 seconds
  CODE
  IF NOT INRANGE(CLOCK(), SELF.LastKeyTime, SELF.LastKeyTime + TIMEOUT)
    SELF.ClearValue()
  END

!==============================================================================
