   MEMBER
   
!region Notices
! ================================================================================
! Notice : Copyright (C) 2018, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
!
!    This file is part of Devuna-ClassLibrary (https://github.com/Devuna/Devuna-ClassLibrary)
!
!    Devuna-ClassLibrary is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-ClassLibrary is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-ClassLibrary.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================
!endregion Notices
!
!ctWinPredefinedColors - Windows Predefined Colors Class
!
!Author:        Randy Rogers <rrogers@devuna.com>
!Copyright:     ©2018 Devuna
!Creation Date: 2018.04.20
!Module:        ctWinPredefinedColors.clw
!Revisions:
!==========
!2018.04.20     initial version
!===============================================================

   MAP
   END
!================================================================
! Includes
!================================================================
      INCLUDE('ctWinPredefinedColors.inc'),ONCE

!================================================================
! Equates
!================================================================

!================================================================
! Declarations
!================================================================
m_ColorQueue   QUEUE(ctWinPredefinedColorsQueueType),PRIVATE
               END
               
!================================================================
! ctWinPredefinedColors implementation                             !
!================================================================
ctWinPredefinedColors.Construct            PROCEDURE()
i     LONG

   CODE
      FREE(m_ColorQueue)
      LOOP i = 1 to 141
         m_ColorQueue.ColorValue = SELF.m_ColorGroup[i].ColorValue
         m_ColorQueue.ColorName  = CLIP(SELF.m_ColorGroup[i].ColorName)
         ADD(m_ColorQueue)
      END 
      RETURN
      
ctWinPredefinedColors.Destruct             PROCEDURE !,VIRTUAL
   CODE
      RETURN
      
ctWinPredefinedColors.GetColorName         PROCEDURE(LONG pColorValue) !,STRING
i           LONG
sColorName  CSTRING(21)
   CODE
     sColorName = 'Custom'
     LOOP i = 1 TO RECORDS(m_ColorQueue)
        GET(m_ColorQueue,i)
        IF m_ColorQueue.ColorValue = pColorValue
           sColorName = m_ColorQueue.ColorName
           BREAK
        END   
     END
     RETURN CLIP(sColorName)
     
ctWinPredefinedColors.GetColorValue        PROCEDURE(*CSTRING pColorName) !,LONG
i           LONG
nColorValue LONG
   CODE
     nColorValue = 0
     LOOP i = 1 TO RECORDS(m_ColorQueue)
        GET(m_ColorQueue,i)
        IF UPPER(m_ColorQueue.ColorName) = UPPER(pColorName)
           nColorValue = m_ColorQueue.ColorValue
           BREAK
        END   
     END
     RETURN nColorValue

ctWinPredefinedColors.GetColorQueue        PROCEDURE(*ctWinPredefinedColorsQueueType pWinColorQueue, BYTE pFreeQueue)   !,LONG,PROC
i           LONG
   CODE
      IF pFreeQueue = TRUE
         FREE(pWinColorQueue)
      END   
      LOOP i = 1 TO RECORDS(m_ColorQueue)
           GET(m_ColorQueue,i)
           pWinColorQueue.ColorName  = m_ColorQueue.ColorName
           pWinColorQueue.ColorValue = m_ColorQueue.ColorValue
           ADD(pWinColorQueue)
      END 
      RETURN RECORDS(m_ColorQueue)