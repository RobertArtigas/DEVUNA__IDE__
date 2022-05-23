#!***********************************************************************************************
#!***********************************************************************************************
#TEMPLATE(mhList,'mhList for Hand-Coded Lists'),FAMILY('ABC')
#INCLUDE('MyABC.tpw')
#!***********************************************************************************************
#! TODO:
#! - Template settings for column sorting
#! - Template settings for locators
#! - New Template that generates the queue
#! - Conditional Icons
#! - Conditional Colors
#! - Conditional Styles
#!
#!***********************************************************************************************
#!***********************************************************************************************
#EXTENSION(mhList,'mhList for Hand-Coded Lists'),PROCEDURE,WINDOW,MULTI,DESCRIPTION(%mhListTemplateDescription())
#!**********
#RESTRICT
  #IF(ITEMS(%Report) > 0)
    #REJECT
  #ELSE
    #ACCEPT
  #ENDIF
#ENDRESTRICT
#!**********
#PREPARE
  #CALL(%SetClassDefaults)
#ENDPREPARE
#!**********
#!LOCALDATA
#!ENDLOCALDATA
#!**********
#BOXED,HIDE,AT(,,0,0)
  #!When creating a new template, leave these %MyThings named as-is, if you want to use MYABC.TPW.
  #PROMPT('',@S30),%MyObjectID,DEFAULT('MyID')
  #PROMPT('',@S30),%MyObjectDefaultName,DEFAULT('mhList'& %ActiveTemplateInstance)
  #PROMPT('',@S30),%MyObjectDefaultClass,DEFAULT('mhList')
  #PROMPT('',@S30),%UntaggedIcon,DEFAULT('BOXEMPTY.ICO')
  #PROMPT('',@S30),%TaggedIcon,DEFAULT('BOXCHECK.ICO')
  #INSERT(%OOPHiddenPrompts(ABC))
#ENDBOXED
#!**********
#SHEET,ADJUST
  #TAB('General')
    #PROMPT('List Control:',FROM(%Control,%ControlIsList())),%ListControl,REQ
    #BOXED('Column Sorting')
      #PROMPT('Enable Default Sort Column',CHECK),%DefaultSortOn,AT(10,,180)
      #BOXED,WHERE(%DefaultSortOn),CLEAR
        #PROMPT('Default Sort Column:',FROM(%ControlField)),%DefaultSortColumn,REQ
          #PREPARE
            #FIX(%Control,%ListControl)
          #ENDPREPARE
      #ENDBOXED
    #ENDBOXED
  #ENDTAB
  #TAB('Marking/Tagging')
    #PROMPT('Marking and/or Tagging:',DROP('None|Marking|Tagging|Both')),%MarkingTagging,DEFAULT('None')
    #BOXED,WHERE(%MarkingTagging<>'None')
      #!PROMPT(%MarkingTaggingModeName() &' Queue Field:',EXPR),%QueueRealMarkField,REQ
      #PROMPT('Marking/Tagging Queue Field:',EXPR),%QueueRealMarkField,REQ
      #BOXED,SECTION
        #BOXED('Marking'),WHERE(%MarkingOn() AND %QueueWinMarkField()),AT(,0)
          #DISPLAY('Win Mark Field:  '& %QueueWinMarkField())
        #ENDBOXED
        #BOXED('Marking'),WHERE(%MarkingOn() AND NOT %QueueWinMarkField()),AT(,0)
          #DISPLAY('Your list control does not have a MARK attribute!')
        #ENDBOXED
        #BOXED('Marking'),WHERE(NOT %MarkingOn() AND %QueueWinMarkField()),AT(,0)
          #DISPLAY('Your list control cannot have a MARK attribute!')
        #ENDBOXED
      #ENDBOXED
      #BOXED('Tagging'),WHERE(%TaggingOn())
        #PROMPT('Tag Icon Column:',FROM(%ControlField)),%TaggingColumn,REQ
          #PREPARE
            #FIX(%Control,%ListControl)
          #ENDPREPARE
        #PROMPT('Queue Field for icon (XXX_Icon):',@S50),%TaggingColumnIconField,REQ
        #PROMPT('Column is only for tagging icon, not data',CHECK),%TaggingColumnExclusive,AT(10,,180)
        #!TODO: %TaggingColumnExclusive
      #ENDBOXED
    #ENDBOXED
  #ENDTAB
  #TAB('Classes')
    #WITH(%ClassItem,%MyObjectID)
      #INSERT(%ClassPrompts(ABC))
    #ENDWITH
  #ENDTAB
#ENDSHEET
#!**********
#AT(%CustomGlobalDeclarations)
  #IF(%TaggingOn())
    #CALL(%StandardAddIconToProject, %UntaggedIcon)
    #CALL(%StandardAddIconToProject, %TaggedIcon)
  #ENDIF
#ENDAT
#!**********
#AT(%mpRscAll)
    #IF(%TaggingOn())
#INSERT(%mpAddIconToProject, %UntaggedIcon)
#INSERT(%mpAddIconToProject, %TaggedIcon)
    #ENDIF
#ENDAT
#!**********
#ATSTART
  #CALL(%AtMyClassStart)
  #CALL(%mhListAtStart)
#ENDAT
#!**********
#AT(%GatherObjects)
  #CALL(%AddObjectList)
#ENDAT
#!**********
#AT(%LocalDataClasses)
#CALL(%GenerateClass)
#CALL(%GenerateColumnEquates)
#ENDAT
#!**********
#AT(%LocalData),PRIORITY(1000)
#INSERT(%AtLocalData)
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),PRIORITY(8010)
#INSERT(%AtWindowManagerInit)
    #PRIORITY(8020)
#INSERT(%AtWindowManagerInitLoad)
    #PRIORITY(8030)
#INSERT(%AtWindowManagerInitSetSort)
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'TakeEvent','(),BYTE'),PRIORITY(3200)
#INSERT(%AtWindowManagerTakeEvent)
#ENDAT
#!**********
#!AT(%WindowEventHandling,'AlertKey'),PRIORITY(5000)
#!ENDAT
#!**********
#AT(%MyClassMethodCodeSection,'SetQueueRecord','()'),PRIORITY(2123)
CLEAR(%ListQueue)
#ENDAT
#!**********
#AT(%LocalProcedures)
#CALL(%GenerateVirtuals(ABC), %MyObjectID, 'Local Objects|MyClass Manager', '%MyClassVirtuals(mhList)')
#ENDAT
#!**********
#AT(%MyClassMethodCodeSection),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
  #CALL(%GenerateParentCall(ABC))
#ENDAT
#!*****************************************************************************
#! The %ActiveTemplateInstance attribute is needed, if there can be multiple
#! instances of this %ActiveTemplate in a particular procedure (if the template
#! has the MULTI attribute, or REQ a local template that has MULTI).  Note
#! that the PREPARE begins with a common, when the %ActiveTemplateInstance
#! attribute is present.  This aligns the call to %FixClassName(...) with the
#! %pClassMethod parameter.
#!***
#GROUP(%MyClassVirtuals, %TreeText, %DataText, %CodeText)
#EMBED(%MyClassMethodDataSection,'MyClass Method Data Section'),%pClassMethod,%pClassMethodPrototype,LABEL,DATA,PREPARE(,%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %DataText)
  #?CODE
  #EMBED(%MyClassMethodCodeSection,'MyClass Method Code Section'),%pClassMethod,%pClassMethodPrototype,PREPARE(,%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %CodeText)
#!***********************************************************************************************
#GROUP(%ControlIsList)
  #CASE(%ControlType)
  #OF('LIST')
  #OROF('COMBO')
    #RETURN(%True)
  #ENDCASE
  #RETURN(%False)
#!***********************************************************************************************
#GROUP(%mhListAtStart)
  #FIX(%Control, %ListControl)
  #EQUATE(%ListQueue, EXTRACT(%ControlStatement, 'FROM', 1))
  #!---
  #DECLARE(%IconList),UNIQUE
  #DECLARE(%IconListType,%IconList)
  #!---
  #IF(%TaggingOn())
    #CALL(%AddBrowseIcon(ABC),%UntaggedIcon)
    #CALL(%AddBrowseIcon(ABC),%TaggedIcon)
  #ENDIF
  #!---
  #IF(%MarkingOn())
    #IF(NOT %QueueWinMarkField())
      #ERROR(%Procedure &': '& %ListControl &' does not have a MARK attribute!')
    #ENDIF
  #ELSE
    #IF(%QueueWinMarkField())
      #ERROR(%Procedure &': '& %ListControl &' cannot have a MARK attribute!')
    #ENDIF
  #ENDIF
#!***********************************************************************************************
#GROUP(%QueueWinMarkField),PRESERVE
  #FIX(%Control, %ListControl)
  #RETURN(EXTRACT(%ControlStatement, 'MARK', 1))
#!***********************************************************************************************
#GROUP(%AtLocalData)
#!***********************************************************************************************
#GROUP(%AtWindowManagerInit)
%MyObject.Init(%ListControl, %ListQueue)
#INSERT(%InitMarking)
#INSERT(%InitTagging)
    #IF(%TaggingOn())
      #FOR(%IconList),WHERE(%IconListType <> 'Index' AND %IconListType <> 'VarIndex')
        #IF(%IconListType = 'File')
          #IF(SUB(%IconList,1,1) = '~')
%ListControl{PROP:IconList, %(INSTANCE(%IconList))} = '%IconList'
          #ELSE
%ListControl{PROP:IconList, %(INSTANCE(%IconList))} = '~%IconList'
          #ENDIF
        #ENDIF
      #ENDFOR
    #ENDIF
#!***
#GROUP(%AtWindowManagerInitLoad)
%MyObject.Load()
#!***
#GROUP(%AtWindowManagerInitSetSort)
    #IF(%DefaultSortOn)
    #DECLARE(%TheReturnedValue)
%MyObject.SetSort(%MyObject:Column:%(%FieldNameForLabel(%DefaultSortColumn)))
    #ENDIF
#!**********
#GROUP(%InitMarking)
    #IF(%MarkingOn() OR %TaggingOn())
      #IF(%QueueWinMarkField())
%MyObject.InitMarking(%QueueRealMarkField, %(%QueueWinMarkField()))
      #ELSE
%MyObject.InitMarking(%QueueRealMarkField)
      #ENDIF
    #ENDIF
#!**********
#GROUP(%InitTagging),PRESERVE,AUTO
    #FIX(%IconList,%UntaggedIcon)
    #EQUATE(%UntaggedIconIndex,INSTANCE(%IconList))
    #FIX(%IconList,%TaggedIcon)
    #EQUATE(%TaggedIconIndex,INSTANCE(%IconList))
    #IF(%TaggingOn())
%MyObject.InitTagging(%MyObject:Column:%(%FieldNameForLabel(%TaggingColumn)), %ListQueue.%TaggingColumnIconField, %TaggedIconIndex, %UntaggedIconIndex)
    #ENDIF
#!***********************************************************************************************
#GROUP(%AtWindowManagerTakeEvent)
  CASE %MyObject.TakeEvent()
    ;OF Level:Notify;  CYCLE
    ;OF Level:Fatal ;  BREAK
  END
#!***********************************************************************************************
#GROUP(%GenerateColumnEquates),PRESERVE,AUTO
%[20]Null ITEMIZE(1),PRE(%MyObject:Column)
    #FIX(%Control,%ListControl)
    #FOR(%ControlField)
%[22](%FieldNameForLabel(%ControlField)) EQUATE
    #ENDFOR
%[20]Null END
#!***********************************************************************************************
#GROUP(%FieldNameForLabel,%FieldNamePossiblyWithDotOrPrefix),AUTO
  #EQUATE(%RetVal, %FieldNamePossiblyWithDotOrPrefix)
  #IF(NOT %FieldNameForLabelContainerStripper('.'))
    #CALL(%FieldNameForLabelContainerStripper, ':')
  #ENDIF
  #RETURN(%RetVal)
#!***********************************************************************************************
#GROUP(%FieldNameForLabelContainerStripper,%DelimiterCharacter),AUTO
  #EQUATE(%BadPos, INSTRING('.', %RetVal, 1, 1))
  #IF(%BadPos<>0)
    #SET(%RetVal, SLICE(%RetVal, %BadPos+1, LEN(%RetVal)))
    #RETURN(%True)
  #ENDIF
  #RETURN(%False)
#!***********************************************************************************************
#GROUP(%mhListTemplateDescription),PRESERVE,AUTO
  #EQUATE(%RetVal, 'mhList for Hand-Coded List: ')
  #IF(%ListControl)
    #FIX(%Control, %ListControl)
    #SET(%RetVal, %RetVal & %ListControl &',FROM('& EXTRACT(%ControlStatement, 'FROM', 1) &')')
  #END
  #RETURN(%RetVal)
#!***********************************************************************************************
#GROUP(%MarkingOn)
  #CASE(%MarkingTagging)
  #OF('Marking')
  #OROF('Both')
    #RETURN(%True)
  #ENDCASE
  #RETURN(%False)
#!***********************************************************************************************
#GROUP(%TaggingOn)
  #CASE(%MarkingTagging)
  #OF('Tagging')
  #OROF('Both')
    #RETURN(%True)
  #ENDCASE
  #RETURN(%False)
#!***********************************************************************************************
#!TODO This doesn't work yet (in the PROMPT display)
#GROUP(%MarkingTaggingModeName)
  #CASE(%MarkingTagging)
  #OF('None')
    #RETURN('None')
  #OF('Marking')
    #RETURN('Marked')
  #OF('Tagging')
    #RETURN('Tagged')
  #OF('Both')
    #RETURN('Marked/Tagged')
  #ENDCASE
#!***********************************************************************************************
