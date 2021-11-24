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
#TEMPLATE(KCR_INIClass,'Devuna INIClass Template'),FAMILY('ABC')
#!
#!
#! ----------------------------------------------------------------
#EXTENSION(KCR_INIClassGlobal,'Add Devuna INIClass to application'),APPLICATION
#! ----------------------------------------------------------------
#DISPLAY('This template adds the Devuna INIClass.')
#DISPLAY('')
#DISPLAY('There are no prompts for this template')
#AT(%BeforeGenerateApplication)
  #CALL(%SetClassDefaults(ABC), 'INIManager', 'INIMgr', 'kcrINIClass')
#ENDAT
#!
#!
#AT(%GlobalData)
  #SET(%ValueConstruct,'CSTRING(''' & SUB(%ProjectTarget,1,LEN(%ProjectTarget)-4)  & ''')')
glo:ModuleName      %ValueConstruct
#ENDAT
#!
#!
#AT (%BeforeCategoryDLLInitCode,'ABC')
INIMgr.SetModuleName(glo:ModuleName)
#ENDAT
#!
#!
#AT(%AfterEntryPointCodeStatement),FIRST,WHERE(%ProgramExtension = 'EXE')
INIMgr.SetModuleName(glo:ModuleName)
#ENDAT
#!
#!

