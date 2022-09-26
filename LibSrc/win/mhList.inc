!ABCIncludeFile

mhList_TRACE                  EQUATE(TRUE)

! RA.2022.07.17: Field name increased to 255 (extended name attributes)

mhList_ColumnQueue            QUEUE,TYPE
ID                              UNSIGNED
FieldName                       CSTRING(255) ! RA.2022.07.17: Need to handle extended name attribute name (and sorting)
FieldRef                        ANY
IconRef                         ANY
StyleRef                        ANY
NormalFGRef                     ANY
NormalBGRef                     ANY
SelectedFGRef                   ANY
SelectedBGRef                   ANY
Header                          CSTRING(255)
                              END

mhList_Locator                CLASS,TYPE,MODULE('mhList.clw'),LINK('mhList.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Value                           CSTRING(40),PROTECTED
Control                         SIGNED,PROTECTED
LastKeyTime                     LONG,PROTECTED
AppendCharacter                 PROCEDURE(STRING C)
Display                         PROCEDURE
GetValue                        PROCEDURE,STRING
CheckTimeout                    PROCEDURE
ClearValue                      PROCEDURE
RemoveCharacter                 PROCEDURE
TakeKey                         PROCEDURE,BYTE
                              END

mhList                        CLASS,TYPE,MODULE('mhList.clw'),LINK('mhList.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
ColumnQueue                     &mhList_ColumnQueue
Locator                         &mhList_Locator
ListControl                     SIGNED
ListQueue                       &QUEUE
RealMarkField                   ANY
WinMarkField                    ANY
MarkAnchor                      LONG
SortColumn                      SIGNED,DIM(6)  !Greg says that the most is 6 for SORT using field names in a string
SortColumns                     BYTE
SortRetainsRecord               BOOL
TaggingColumn                   LONG
TaggingIconField                ANY
TaggedIconIndex                 BYTE
UntaggedIconIndex               BYTE

!--- Public Methods
Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
FetchColumnQueue                PROCEDURE(UNSIGNED ColumnID),BYTE,PROC
FreeColumnQueue                 PROCEDURE
DeleteColumnQueue               PROCEDURE
Init                            PROCEDURE(SIGNED ListControl,*QUEUE ListQueue)
InitMarking                     PROCEDURE(*? RealMarkField,<*? WinMarkField>)
InitTagging                     PROCEDURE(LONG TaggingColumn,*? TaggingIconField,BYTE TaggedIconIndex,BYTE UntaggedIconIndex)
Fetch                           PROCEDURE(<UNSIGNED RowNum>),BYTE,PROC
IsMarked                        PROCEDURE,BOOL,VIRTUAL
ListZone                        PROCEDURE,LONG
Load                            PROCEDURE,VIRTUAL
Mark                            PROCEDURE(BYTE MarkValue),VIRTUAL
Mark                            PROCEDURE,VIRTUAL
Records                         PROCEDURE,UNSIGNED,VIRTUAL
SetQueueRecord                  PROCEDURE,VIRTUAL
SetSort                         PROCEDURE(UNSIGNED ClickedColumn),VIRTUAL  !TODO: Add more columns later, up to 5
TakeEvent                       PROCEDURE,BYTE,VIRTUAL
TakeNewSelection                PROCEDURE,BYTE,VIRTUAL
TakeSelected                    PROCEDURE,BYTE,VIRTUAL
TakeAccepted                    PROCEDURE,BYTE,VIRTUAL
TakeIconClick                   PROCEDURE(UNSIGNED ColumnID),BYTE,VIRTUAL
TakeSortEvent                   PROCEDURE,BYTE
Unmark                          PROCEDURE,VIRTUAL

!--- Protected Methods
ApplySort                       PROCEDURE,VIRTUAL,PROTECTED
SetColumnHeader                 PROCEDURE(UNSIGNED ColumnID,STRING Header),VIRTUAL,PROTECTED
SetPrimarySortColumn            PROCEDURE(UNSIGNED ClickedColumn),VIRTUAL,PROTECTED
SetSortColumn                   PROCEDURE(UNSIGNED ClickedColumn,BYTE SortColumnIndex, SHORT Direction),VIRTUAL,PROTECTED
                              END
