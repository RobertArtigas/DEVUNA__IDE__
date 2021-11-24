#TEMPLATE( RifVersionRes, 'Rif Version Resource' ), FAMILY('ABC'),FAMILY('CW20'),FAMILY('IPServer')
#HELP('ClarionHelp.chm')
#EXTENSION (RifVersionRes, 'Rif Version Resource'), APPLICATION, HLP('~TPLGlobExtVerResource')
#PREPARE
  #CALL( %BuildLangList )
  #CALL( %BuildCPList )
  #CALL( %verSetDefaults )
#ENDPREPARE
#SHEET,HScroll
  #TAB('General'), HLP('~TPLGlobExtVerResource_Gen')
    #PROMPT( 'Pass version data to SetupBuilder', CHECK ),%verUseSetupBuilder, DEFAULT(1), AT(10)      
    #ENABLE( %verUseSetupBuilder )
       #PROMPT( 'Version Filename for SetupBuilder: ', @S128 ), %verVersionFile
       #DISPLAY('At the top of your SB script, ')
       #DISPLAY('use the GetIni script command to fill [PRODUCTVER] from INI section build, INI value version')
       #DISPLAY(' ')
    #ENDENABLE    
    #PROMPT( 'Company Name: ', @S128 ), %verCoName
    #PROMPT( 'Automate copyright line text', CHECK ),%verAutomateCopyright, DEFAULT(1), AT(10)      
    #ENABLE( NOT %verAutomateCopyright )
        #PROMPT( 'Legal Copyright: ', @s128 ), %verCopyright
    #ENDENABLE    
    #ENABLE( %verAutomateCopyright )
        #PROMPT( 'Copyright start year (yyyy): ', @n4), %verCopyrightStartYear
    #ENDENABLE    
    #DISPLAY(' ')
    #PROMPT( 'Legal Trademarks: ', @s128 ), %verTrademarks
    #PROMPT( 'Comments: ', @s128 ), %verComments
  #ENDTAB
  #TAB('Product Version'), HLP('~TPLGlobExtVerResource_ProdVer')
    #PROMPT( 'Use External Product Information', CHECK ), %verExtProdVersion, DEFAULT( 0 ), AT( 10 )
    #ENABLE( %verExtProdVersion )
      #PROMPT( 'Source Version File: ', OPENDIALOG( 'Select Version File', 'Version Information|*.Version' ) ), %verSourceFile, REQ
    #ENDENABLE
    #ENABLE( NOT %verExtProdVersion )
      #PROMPT( 'Product Name: ', @S128 ), %verProdName      
      #PROMPT( 'Product Major Version: ', @n4 ), %verProdMajVer
      #PROMPT( 'Use Year as Major Version', CHECK ),%verProdMajVerYear, DEFAULT(1), AT(10)      
      #PROMPT( 'Product Minor Version: ', @n4 ), %verProdMinVer
      #PROMPT( 'Use Month as Minor Version', CHECK ),%verProdMinVerMonth, DEFAULT(1), AT(10)      
      #PROMPT( 'Product Sub Version: ', @n4 ), %verProdSubVer
      #PROMPT( 'Use Day as Sub Version', CHECK ),%verProdSubVerDay, DEFAULT(1), AT(10)      
      #PROMPT( 'Use Generated Build Number', CHECK ),%verProdGenBuildNo, DEFAULT(1), AT(10)
      #ENABLE( NOT %verProdGenBuildNo )
        #PROMPT( 'Product Build Number: ', @n4 ), %verProdBuildNo
      #ENDENABLE
    #ENDENABLE
  #ENDTAB
  #TAB('File Version'), HLP('~TPLGlobExtVerResource_FileVer')
    #PROMPT( 'File Description: ', @s128 ), %verDesc
    #PROMPT( 'Same as Product Version Information', CHECK ), %verFileAsProdVersion, DEFAULT( 0 ), AT( 10 )
    #ENABLE(NOT %verFileAsProdVersion)
        #PROMPT( 'Internal Name: ', @s128 ), %verIntName
        #PROMPT( 'File Major Version: ', @n4 ), %verFileMajVer
        #PROMPT( 'File Minor Version: ', @n4 ), %verFileMinVer
        #PROMPT( 'File Sub Version:   ', @n4 ), %verFileSubVer
        #PROMPT( 'Use Generated Build Number', CHECK ),%verFileGenBuildNo, DEFAULT(1), AT(10)
        #ENABLE(NOT %verFileGenBuildNo)
          #PROMPT( 'File Build Number: ', @n4 ), %verFileBuildNo
        #ENDENABLE
    #ENDENABLE
    #PROMPT( 'Pre-Release Build', CHECK ), %verFilePreRelease, AT( 10 )
  #ENDTAB
  #TAB('Locale'), HLP('~TPLGlobExtVerResource_Locale')
    #PROMPT( 'Language: ', FROM( %verLangID ) ), %verSelLangID
    #PROMPT( 'Code Page: ', FROM( %verCPID ) ), %verSelCPID
  #ENDTAB
  #TAB('Clarion'), HLP('~TPLGlobExtVerResource_Clarion')
    #PROMPT('Include Clarion Version Information', CHECK ), %verIncludeCW, DEFAULT( 1 ), AT( 10 )
    #ENABLE(%verIncludeCW)
      #PREPARE
        #SET(%verClarionVersion,%CWVersion)
        #SET(%verTemplateFamily,%AppTemplateFamily)
        #SET(%verTemplateVersion,%CWTemplateVersion)
      #ENDPREPARE
      #PROMPT('Clarion version',@s128),%verClarionVersion,Default(%CWVersion)
      #PROMPT('Template family',@s128),%verTemplateFamily,Default(%AppTemplateFamily)
      #PROMPT('Template version',@s128),%verTemplateVersion,Default(%CWTemplateVersion)
    #ENDENABLE
  #ENDTAB
  #TAB('User'), HLP('~TPLGlobExtVerResource_User')
    #BOXED('User defined values'), SECTION
      #DISPLAY('')
      #DISPLAY('You can include up to four user defined items.')
      #DISPLAY('If an item label is not blank, the label and value will')      
      #DISPLAY('be added to the version information.')      
      #DISPLAY('')
      #!SHEET, AT(10,,174,)
      #SHEET, AT(10,,350,)
        #TAB('Item 1')
        #BOXED('')
          #PROMPT('Label',@s128),%verUserLabel1,Default(''),AT(60)
          #PROMPT('Value',@s128),%verUserValue1,Default(''),AT(60)
        #ENDBOXED
        #ENDTAB
        #TAB('Item 2')
        #BOXED('')
          #PROMPT('Label',@s128),%verUserLabel2,Default(''),AT(60)
          #PROMPT('Value',@s128),%verUserValue2,Default(''),AT(60)
        #ENDBOXED
        #ENDTAB
        #TAB('Item 3')
        #BOXED('')
          #PROMPT('Label',@s128),%verUserLabel3,Default(''),AT(60)
          #PROMPT('Value',@s128),%verUserValue3,Default(''),AT(60)
        #ENDBOXED
        #ENDTAB
        #TAB('Item 4')      
        #BOXED('')
          #PROMPT('Label',@s128),%verUserLabel4,Default(''),AT(60)
          #PROMPT('Value',@s128),%verUserValue4,Default(''),AT(60)
        #ENDBOXED
        #ENDTAB
      #ENDSHEET
    #ENDBOXED
  #ENDTAB
#ENDSHEET
#AT(%AfterGeneratedApplication)
  #IF(NOT %EditFilename)
     #CALL(%BuildVersionResourceFile)
  #ENDIF
#ENDAT
#!AT()
#! "%verFileMajVer.%verFileMinVer.%verFileBuildNo"
#!ENDAT
#GROUP(%BuildVersionResourceFile)
  #CALL(%BuildLangList)
  #CALL(%BuildCPList)
  #DECLARE( %verBuildFile )
  #DECLARE( %verBuildLine )
  #DECLARE( %verCurBuildNo )
  #DECLARE( %verFileAsProdLine )
  #DECLARE( %verBuildEqu )
  #DECLARE( %OriginalFileName )
  #IF(%verProdMajVerYear)
     #SET(%verProdMajVer,YEAR(TODAY()))
  #ENDIF 
  #IF(%verProdMinVerMonth)
     #SET(%verProdMinVer,MONTH(TODAY()))
  #ENDIF   
  #IF(%verProdSubVerDay)
     #SET(%verProdSubVer,DAY(TODAY()))
  #ENDIF   
  #IF( NOT %verExtProdVersion AND %verProdGenBuildNo )
    #SET( %verBuildFile, CLIP( %ProjectTarget ) )
    #SET( %verBuildFile, SUB( %verBuildFile, 1, LEN( CLIP( %verBuildFile ) ) - 4 ) & 'Product.BLD' )
    #IF( FILEEXISTS( %verBuildFile ) )
      #OPEN( %verBuildFile ), READ
      #READ( %verBuildLine )
      #CLOSE( %verBuildFile )
    #END
    #IF( CLIP( %verBuildLine ) <> '' )
      #SET( %verCurBuildNo, SLICE( %verBuildLine, INSTRING( '''', %verBuildLine, 1, 1 ) + 1, LEN( CLIP( %verBuildLine ) ) - 2 ) )
    #ENDIF
    #SET( %verCurBuildNo, %verCurBuildNo + 1 )
    #CREATE( %verBuildFile )
    #SET( %verBuildEqu, CLIP( %ProjectTarget ) )
    #SET( %verBuildEqu, SUB( %verBuildEqu, 1, LEN( CLIP( %verBuildEqu ) ) - 4 ) & 'Product' )
%[50]verBuildEqu  EQUATE('%verCurBuildNo')
    #CLOSE( %verBuildFile )
    #SET( %verProdBuildNo, %verCurBuildNo )
  #ENDIF
  #IF(NOT %verFileAsProdVersion AND %verFileGenBuildNo )
    #SET( %verBuildLine, '' )
    #SET( %verCurBuildNo, 0 )
    #SET( %verBuildFile, CLIP( %ProjectTarget ) )
    #SET( %verBuildFile, SUB( %verBuildFile, 1, LEN( CLIP( %verBuildFile ) ) - 4 ) & 'File.BLD' )
    #IF( FILEEXISTS( %verBuildFile ) )
      #OPEN( %verBuildFile ), READ
      #READ( %verBuildLine )
      #CLOSE( %verBuildFile )
    #END
    #IF( CLIP( %verBuildLine ) <> '' )
      #SET( %verCurBuildNo, SLICE( %verBuildLine, INSTRING( '''', %verBuildLine, 1, 1 ) + 1, LEN( CLIP( %verBuildLine ) ) - 2 ) )
    #ENDIF
    #SET( %verCurBuildNo, %verCurBuildNo + 1 )
    #CREATE( %verBuildFile )
    #SET( %verBuildEqu, CLIP( %ProjectTarget ) )
    #SET( %verBuildEqu, SUB( %verBuildEqu, 1, LEN( CLIP( %verBuildEqu ) ) - 4 ) & 'File' )
%[50]verBuildEqu  EQUATE('%verCurBuildNo')
    #CLOSE( %verBuildFile )
    #SET( %verFileBuildNo, %verCurBuildNo )
  #ENDIF
  #IF(%verFileAsProdVersion)
    #SET( %verIntName, %verProdName)
    #SET( %verFileMajVer, %verProdMajVer)
    #SET( %verFileMinVer, %verProdMinVer)
    #SET( %verFileSubVer, %verProdSubVer)
    #SET( %verFileBuildNo, %verProdBuildNo)
  #ENDIF
  #FIX(%verLangID, %verSelLangID)
  #FIX(%verCPID, %verSelCPID)
  #DECLARE( %verFileName )
  #DECLARE( %verBlock )
  #IF(%verProdMajVer = '')
    #SET( %verProdMajVer, 0 )
  #ENDIF
  #IF(%verProdMinVer = '')
    #SET( %verProdMinVer, 0 )
  #ENDIF
  #IF(%verProdSubVer = '')
    #SET( %verProdSubVer, 0 )
  #ENDIF
  #IF(%verProdBuildNo = '')
    #SET( %verProdBuildNo, 0 )
  #ENDIF
  #IF(%verFileMajVer = '')
    #SET( %verFileMajVer, 0 )
  #ENDIF
  #IF(%verFileMinVer = '')
    #SET( %verFileMinVer, 0 )
  #ENDIF
  #IF(%verFileSubVer = '')
    #SET( %verFileSubVer, 0 )
  #ENDIF
  #IF(%verFileBuildNo = '')
    #SET( %verFileBuildNo, 0 )
  #ENDIF
  #IF( %verExtProdVersion )
    #DECLARE( %verSourceName )
    #DECLARE( %verSourceVer )
    #DECLARE( %verSourceVerLine )
    #DECLARE( %verSourceLine )
    #OPEN( %verSourceFile ), READ
    #LOOP
      #READ( %verSourceLine )
      #IF( %verSourceLine = %EOF )
        #BREAK
      #ENDIF
      #IF( INSTRING( 'PRODUCTVERSION', UPPER( %verSourceLine ), 1, 1 ) )
        #IF( INSTRING( 'VALUE', UPPER( %verSourceLine ), 1, 1 ) = 0 )
          #SET( %verSourceVerLine, CLIP( %verSourceLine ) )
        #ENDIF
      #ENDIF
      #IF( INSTRING( '"PRODUCTNAME"', UPPER( %verSourceLine ), 1, 1 ) )
        #SET( %verSourceName, CLIP( %verSourceLine ) )
      #ENDIF
      #IF( INSTRING( '"PRODUCTVERSION"', UPPER( %verSourceLine ), 1, 1 ) )
        #SET( %verSourceVer, CLIP( %verSourceLine ) )
      #ENDIF
    #ENDLOOP
    #CLOSE( %verSourceFile )
  #ENDIF
  #IF (%verVersionFile > ' ')
  #CREATE(%verVersionFile)
[build]
version=%verFileMajVer.%verFileMinVer.%verFileSubVer.%verFileBuildNo
  #CLOSE(%verVersionFile)
  #ENDIF 
  #SET( %verFileName, CLIP( %ProjectTarget ) )
  #SET( %verFileName, SUB( %verFileName, 1, LEN( CLIP( %verFileName ) ) - 3 ) & 'Version' )
  #SET(%OriginalFileName, TAILNAME(%ProjectTarget) )
  #IF( %verExtProdVersion AND %verFileAsProdVersion )
    #SET(%verFileAsProdLine, SUB(%verSourceVerLine,16, len(clip( %verSourceVerLine)) ))
  #ENDIF
  #CREATE( %verFileName )
LANGUAGE %verLangValue

1 VERSIONINFO
  #IF( %verFileAsProdLine )
 FILEVERSION %verFileAsProdLine 
  #ELSE
 FILEVERSION %verFileMajVer,%verFileMinVer,%verFileSubVer,%verFileBuildNo
  #ENDIF
  #IF( %verExtProdVersion )
 %verSourceVerLine
  #ELSE
 PRODUCTVERSION %verProdMajVer,%verProdMinVer,%verProdSubVer,%verProdBuildNo
  #ENDIF
 FILEFLAGSMASK 0x3FL
  #IF( %ApplicationDebug )
    #IF( %verFilePreRelease )
 FILEFLAGS 0x3L
    #ELSE
 FILEFLAGS 0x1L
    #ENDIF
  #ELSE
    #IF( %verFilePreRelease )
 FILEFLAGS 0x2L
    #ELSE
 FILEFLAGS 0
    #ENDIF
  #ENDIF
 FILEOS VOS__WINDOWS32
  #CASE( %ProgramExtension )
  #OF( 'EXE' )
 FILETYPE VFT_APP
  #OF( 'DLL' )
 FILETYPE VFT_DLL
  #OF( 'LIB' )
 FILETYPE VFT_STATIC_LIB
  #ELSE
 FILETYPE VFT_UNKNOWN
  #ENDCASE
 FILESUBTYPE 0x0L
BEGIN
  BLOCK "StringFileInfo"
  BEGIN
    #SET( %verBlock, SUB( %verLangValue, 3, 7 ) & %verCPValue )
    BLOCK "%verBlock"
      BEGIN
    #IF( CLIP( %verCoName ) <> '' )
        VALUE "CompanyName", "%verCoName\0"
    #ENDIF
    #IF( CLIP( %verDesc ) <> '' )
        VALUE "FileDescription", "%verDesc\0"
    #ENDIF
        VALUE "FileVersion", "%verFileMajVer.%verFileMinVer.%verFileSubVer.%verFileBuildNo\0"
    #IF( CLIP( %verIntName ) <> '' )
        VALUE "InternalName", "%verIntName\0"
    #ENDIF
    #IF( %verAutomateCopyright)
        #SET(%verCopyright, 'Copyright (c) ' & %verCoName & ' ' & %verCopyrightStartYear & '-' & YEAR(TODAY()))
        VALUE "LegalCopyright", "%verCopyright\0"    
    #ELSE
        #IF( CLIP( %verCopyright ) <> '' )
        VALUE "LegalCopyright", "%verCopyright\0"
        #ENDIF
    #ENDIF 
    #IF( CLIP( %verTrademarks ) <> '' )
        VALUE "LegalTrademarks", "%verTrademarks\0"
    #ENDIF
    #IF( CLIP( %OriginalFileName ) <> '' )
        VALUE "OriginalFilename", "%OriginalFileName\0"
    #ENDIF
    #IF( %verExtProdVersion )
  %verSourceName
    #ELSE
      #IF( CLIP( %verProdName ) <> '' )
        VALUE "ProductName", "%verProdName\0"
      #ENDIF
    #ENDIF
    #IF( %verExtProdVersion )
  %verSourceVer
    #ELSE
        VALUE "ProductVersion", "%verProdMajVer.%verProdMinVer.%verProdSubVer.%verProdBuildNo\0"
    #ENDIF
    #IF( CLIP( %verComments ) <> '' )
        VALUE "Comments", "%verComments\0"
    #ENDIF
    #IF( %verIncludeCW )
        VALUE "Clarion Version", "%verClarionVersion\0"
        VALUE "Template Family", "%verTemplateFamily\0"
        VALUE "Template Version", "%verTemplateVersion\0"
    #ENDIF
    #IF( CLIP( %verUserLabel1 ) <> '' )
        VALUE "%verUserLabel1", "%verUserValue1\0"
    #ENDIF
    #IF( CLIP( %verUserLabel2 ) <> '' )
        VALUE "%verUserLabel2", "%verUserValue2\0"
    #ENDIF
    #IF( CLIP( %verUserLabel3 ) <> '' )
        VALUE "%verUserLabel3", "%verUserValue3\0"
    #ENDIF
    #IF( CLIP( %verUserLabel4 ) <> '' )
        VALUE "%verUserLabel4", "%verUserValue4\0"
    #ENDIF
#EMBED(%VerResourceValueList,'Clarion Rif Version Resource: Inside Value List'),NOINDENT
      END
    END
    BLOCK "VarFileInfo"
    BEGIN
        VALUE "Translation", %verLangValue, %verCPDecValue
    END
END
#CLOSE( %verFileName )
#PROJECT( %verFileName )
#!--------------------------------------------------------------------------------
#!--------------------------------------------------------------------------------
#GROUP(%BuildLangList)
  #DECLARE( %verLangID ),UNIQUE
  #DECLARE( %verLangValue, %verLangID )
  #ADD( %VerLangID, 'Arabic' )
  #SET( %verLangValue, '0x0401' )
  #ADD( %verLangID, 'Bulgarian' )
  #SET( %verLangValue, '0x0402' )
  #ADD( %verLangID, 'Catalan' )
  #SET( %verLangValue, '0x0403' )
  #ADD( %verLangID, 'Traditional Chinese' )
  #SET( %verLangValue, '0x0404' )
  #ADD( %verLangID, 'Czech' )
  #SET( %verLangValue, '0x0405' )
  #ADD( %verLangID, 'Danish' )
  #SET( %verLangValue, '0x0406' )
  #ADD( %verLangID, 'German' )
  #SET( %verLangValue, '0x0407' )
  #ADD( %verLangID, 'Greek' )
  #SET( %verLangValue, '0x0408' )
  #ADD( %verLangID, 'U.S. English' )
  #SET( %verLangValue, '0x0409' )
  #ADD( %verLangID, 'Castilian Spanish' )
  #SET( %verLangValue, '0x040A' )
  #ADD( %verLangID, 'Finnish' )
  #SET( %verLangValue, '0x040B' )
  #ADD( %verLangID, 'French' )
  #SET( %verLangValue, '0x040C' )
  #ADD( %verLangID, 'Hebrew' )
  #SET( %verLangValue, '0x040D' )
  #ADD( %verLangID, 'Hungarian' )
  #SET( %verLangValue, '0x040E' )
  #ADD( %verLangID, 'Icelandic' )
  #SET( %verLangValue, '0x040F' )
  #ADD( %verLangID, 'Italian' )
  #SET( %verLangValue, '0x0410' )
  #ADD( %verLangID, 'Japanese' )
  #SET( %verLangValue, '0x0411' )
  #ADD( %verLangID, 'Korean' )
  #SET( %verLangValue, '0x0412' )
  #ADD( %verLangID, 'Dutch' )
  #SET( %verLangValue, '0x0413' )
  #ADD( %verLangID, 'Norwegian - Bokmal' )
  #SET( %verLangValue, '0x0414' )
  #ADD( %verLangID, 'Polish' )
  #SET( %verLangValue, '0x0415' )
  #ADD( %verLangID, 'Portuguese (Brazil)' )
  #SET( %verLangValue, '0x0416' )
  #ADD( %verLangID, 'Rhaeto-Romanic' )
  #SET( %verLangValue, '0x0417' )
  #ADD( %verLangID, 'Romanian' )
  #SET( %verLangValue, '0x0418' )
  #ADD( %verLangID, 'Russian' )
  #SET( %verLangValue, '0x0419' )
  #ADD( %verLangID, 'Croato-Serbian (Latin)' )
  #SET( %verLangValue, '0x041A' )
  #ADD( %verLangID, 'Slovak' )
  #SET( %verLangValue, '0x041B' )
  #ADD( %verLangID, 'Slovenian' )
  #SET( %verLangValue, '0x0424' )
  #ADD( %verLangID, 'Albanian' )
  #SET( %verLangValue, '0x041C' )
  #ADD( %verLangID, 'Swedish' )
  #SET( %verLangValue, '0x041D' )
  #ADD( %verLangID, 'Thai' )
  #SET( %verLangValue, '0x041E' )
  #ADD( %verLangID, 'Turkish' )
  #SET( %verLangValue, '0x041F' )
  #ADD( %verLangID, 'Urdu' )
  #SET( %verLangValue, '0x0420' )
  #ADD( %verLangID, 'Bahasa' )
  #SET( %verLangValue, '0x0421' )
  #ADD( %verLangID, 'Simplified Chinese' )
  #SET( %verLangValue, '0x0804' )
  #ADD( %verLangID, 'Swiss German' )
  #SET( %verLangValue, '0x0807' )
  #ADD( %verLangID, 'U.K. English' )
  #SET( %verLangValue, '0x0809' )
  #ADD( %verLangID, 'Mexican Spanish' )
  #SET( %verLangValue, '0x080A' )
  #ADD( %verLangID, 'Belgian French' )
  #SET( %verLangValue, '0x080C' )
  #ADD( %verLangID, 'Swiss Italian' )
  #SET( %verLangValue, '0x0810' )
  #ADD( %verLangID, 'Belgian Dutch' )
  #SET( %verLangValue, '0x0813' )
  #ADD( %verLangID, 'Norwegian - Nynorsk' )
  #SET( %verLangValue, '0x0814' )
  #ADD( %verLangID, 'Serbo-Croatian (Cyrillic)' )
  #SET( %verLangValue, '0x081A' )
  #ADD( %verLangID, 'Portuguese (Portugal)' )
  #SET( %verLangValue, '0x0816' )
  #ADD( %verLangID, 'Canadian French' )
  #SET( %verLangValue, '0x0C0C' )
  #ADD( %verLangID, 'Swiss French' )
  #SET( %verLangValue, '0x100C' )
  #ADD( %verLangID, 'Lithuanian' )
  #SET( %verLangValue, '0x0427' )
#!--------------------------------------------------------------------------------
#!--------------------------------------------------------------------------------
#GROUP(%BuildCPList)
  #DECLARE( %verCPID ),MULTI
  #DECLARE( %verCPValue, %verCPID )
  #DECLARE( %verCPDecValue, %verCPID )  
  #ADD( %verCPID, '7-bit ASCII' )
  #SET( %verCPValue, '0000' )
  #SET( %verCPDecValue, '0' )  
  #ADD( %verCPID, 'Japan (Shift - JIS X-0208)' )
  #SET( %verCPValue, '03A4' )
  #SET( %verCPDecValue, '932' )    
  #ADD( %verCPID, 'Korea (Shift - KSC 5601)' )
  #SET( %verCPValue, '03B5' )
  #SET( %verCPDecValue, '949' )  
  #ADD( %verCPID, 'Taiwan (Big5)' )
  #SET( %verCPValue, '03B6' )
  #SET( %verCPDecValue, '950' )    
  #ADD( %verCPID, 'Unicode' )
  #SET( %verCPValue, '04B0' )
  #SET( %verCPDecValue, '1200' )    
  #ADD( %verCPID, 'Latin-2 (Eastern European)' )
  #SET( %verCPValue, '04E2' )
  #SET( %verCPDecValue, '1250' )    
  #ADD( %verCPID, 'Cyrillic' )
  #SET( %verCPValue, '04E3' )
  #SET( %verCPDecValue, '1251' )    
  #ADD( %verCPID, 'Multilingual' )
  #SET( %verCPValue, '04E4' )
  #SET( %verCPDecValue, '1252' )    
  #ADD( %verCPID, 'Greek' )
  #SET( %verCPValue, '04E5' )
  #SET( %verCPDecValue, '1253' )    
  #ADD( %verCPID, 'Turkish' )
  #SET( %verCPValue, '04E6' )
  #SET( %verCPDecValue, '1254' )    
  #ADD( %verCPID, 'Hebrew' )
  #SET( %verCPValue, '04E7' )
  #SET( %verCPDecValue, '1255' )    
  #ADD( %verCPID, 'Arabic' )
  #SET( %verCPValue, '04E8' )
  #SET( %verCPDecValue, '1256' )    

#!--------------------------------------------------------------------------------
#!--------------------------------------------------------------------------------
#GROUP( %verSetDefaults )
  #DECLARE( %verLine )
  #DECLARE( %verValStart )
  #OPEN( 'Default.Version' ),READ
  #LOOP
    #READ( %verLine )
    #IF( %verLine = %EOF )
      #BREAK
    #ENDIF
    #IF( CLIP( %verCoName ) = '' )
      #IF( INSTRING( '"COMPANYNAME"', UPPER( %verLine ), 1, 1 ) )
        #SET( %verValStart, INSTRING( ',', %verLine, 1, 1 ) + 1 )
        #LOOP
          #IF( SUB( %verLine, %verValStart, 1 ) = '"' )
            #BREAK
          #ENDIF
          #SET( %verValStart, %verValStart + 1 )
        #ENDLOOP
        #SET( %verCoName, SLICE( %verLine, %verValStart + 1, LEN( CLIP( %verLine ) ) - 3 ) )
      #ENDIF
    #ENDIF
    #IF( CLIP( %verCopyright ) = '' )
      #IF( INSTRING( '"LEGALCOPYRIGHT"', UPPER( %verLine ), 1, 1 ) )
        #SET( %verValStart, INSTRING( ',', %verLine, 1, 1 ) + 1 )
        #LOOP
          #IF( SUB( %verLine, %verValStart, 1 ) = '"' )
            #BREAK
          #ENDIF
          #SET( %verValStart, %verValStart + 1 )
        #ENDLOOP
        #SET( %verCopyright, SLICE( %verLine, %verValStart + 1, LEN( CLIP( %verLine ) ) - 3 ) )
      #ENDIF
    #ENDIF
    #IF( CLIP( %verTrademarks ) = '' )
      #IF( INSTRING( '"LEGALTRADEMARKS"', UPPER( %verLine ), 1, 1 ) )
        #SET( %verValStart, INSTRING( ',', %verLine, 1, 1 ) + 1 )
        #LOOP
          #IF( SUB( %verLine, %verValStart, 1 ) = '"' )
            #BREAK
          #ENDIF
          #SET( %verValStart, %verValStart + 1 )
        #ENDLOOP
        #SET( %verTrademarks, SLICE( %verLine, %verValStart + 1, LEN( CLIP( %verLine ) ) - 3 ) )
      #ENDIF
    #ENDIF
    #IF( CLIP( %verSelLangID ) = '' )
      #IF( INSTRING( '"LANGUAGE"', UPPER( %verLine ), 1, 1 ) )
        #SET( %verValStart, INSTRING( ',', %verLine, 1, 1 ) + 1 )
        #LOOP
          #IF( SUB( %verLine, %verValStart, 1 ) = '"' )
            #BREAK
          #ENDIF
          #SET( %verValStart, %verValStart + 1 )
        #ENDLOOP
        #SET( %verSelLangID, SLICE( %verLine, %verValStart + 1, LEN( CLIP( %verLine ) ) - 3 ) )
      #ENDIF
    #ENDIF
    #IF( CLIP( %verSelCPID ) = '' )
      #IF( INSTRING( '"CODEPAGE"', UPPER( %verLine ), 1, 1 ) )
        #SET( %verValStart, INSTRING( ',', %verLine, 1, 1 ) + 1 )
        #LOOP
          #IF( SUB( %verLine, %verValStart, 1 ) = '"' )
            #BREAK
          #ENDIF
          #SET( %verValStart, %verValStart + 1 )
        #ENDLOOP
        #SET( %verSelCPID, SLICE( %verLine, %verValStart + 1, LEN( CLIP( %verLine ) ) - 3 ) )
      #ENDIF
    #ENDIF
  #ENDLOOP
  #CLOSE( 'Default.Version' )
#!---------------------------------------------------------------------------------------
#CODE(RifStoreCompileDateInVariable,'Store compile date/time in variables')
#!---------------------------------------------------------------------------------------
#PREPARE
  #!INSERT(%ITGlobalVars)
  #!SET(%ITTemplateName,'Store compile date/time in variables')
#ENDPREPARE
#!CALL(%ITInsertHeader)
#DISPLAY(),AT(,,,3)
#!
#PROMPT('Variable for compile date',FIELD),%ITCompileDateVariable
#PROMPT('Variable for compile time',FIELD),%ITCompileTimeVariable
#PROMPT('Variable for productver',FIELD),%ITProductVerVariable
#DISPLAY(),AT(,,,4)
#PROMPT(' Format to string',CHECK),%ITCompileDateTimeInString
#ENABLE(%ITCompileDateTimeInString=%True)
#PREPARE
  #DECLARE(%ITTodayp)
  #DECLARE(%ITClockp)
  #DECLARE(%ITStringp)
  #SET(%ITTodayp,Today())
  #SET(%ITClockp,Clock())
   #IF(%ITCompileDateTimeInString=%True)
     #IF(%ITCompileDateTimeStringVariable)
       #IF(%ITCompileDateVariable <> '' And %ITCompileTimeVariable <> '' And %ITCompileDateTimeSeparator <> '')
         #SET(%ITStringp, Left(Clip(Format(%ITTodayp,%ITCompileDatePicture))) &  %ITCompileDateTimeSeparator &  Left(Clip(Format(%ITClockp,%ITCompileTimePicture))))
       #ELSIF(%ITCompileDateVariable <> '' And %ITCompileTimeVariable = '')
         #SET(%ITStringp, Left(Format(%ITTodayp,%ITCompileDatePicture)))
       #ELSIF(%ITCompileTimeVariable <> '')
         #SET(%ITStringp, Left(Format(%ITClockp,%ITCompileTimePicture)))
       #ENDIF
     #ENDIF
   #ENDIF
  #ENDPREPARE
  #BOXED('Compile Date/Time String')
    #DISPLAY(),AT(,,,2)
    #PROMPT('Variable for compile string',FIELD),%ITCompileDateTimeStringVariable
    #ENABLE(%ITCompileDateVariable<>'')
      #PROMPT('Date picture',PICTURE),%ITCompileDatePicture,REQ,Default('@d17')
    #ENDENABLE
    #ENABLE(%ITCompileTimeVariable<>'')
      #PROMPT('Time picture',PICTURE),%ITCompileTimePicture,REQ,Default('@t7')
      #PROMPT('Separator',@S20),%ITCompileDateTimeSeparator,DEFAULT(' - ')
    #ENDENABLE
    #DISPLAY(),AT(,,,3)
    #DISPLAY('Results:'),PROP(PROP:FontStyle,700)
    #DISPLAY('  ' & %ITStringp)
    #DISPLAY(),AT(,,,2)
  #ENDBOXED
#ENDENABLE
#!
#DECLARE(%ITToday)
#DECLARE(%ITClock)
#SET(%ITToday,Today())
#SET(%ITClock,Clock())
 #IF(%ITCompileDateVariable)
%ITCompileDateVariable = %ITToday
 #ENDIF
 #IF(%ITCompileTimeVariable)
%ITCompileTimeVariable = %ITClock
 #ENDIF
 #IF(%ITProductVerVariable)
 %ITProductVerVariable = '%verProdMajVer.%verProdMinVer.' & %verFileBuildNo + 1  ! because link comes after generate, so the # will be 1 higher. 
 #ENDIF 
 #IF(%ITCompileDateTimeInString=%True)
   #IF(%ITCompileDateTimeStringVariable)
     #IF(%ITCompileDateVariable <> '' And %ITCompileTimeVariable <> '' And %ITCompileDateTimeSeparator <> '')
%ITCompileDateTimeStringVariable = Left(Clip(Format(%ITToday,%ITCompileDatePicture))) & '%ITCompileDateTimeSeparator' & Left(Clip(Format(%ITClock,%ITCompileTimePicture)))
     #ELSIF(%ITCompileDateVariable <> '' And %ITCompileTimeVariable = '')
%ITCompileDateTimeStringVariable = Left(Format(%ITToday,%ITCompileDatePicture))
     #ELSIF(%ITCompileTimeVariable <> '')
%ITCompileDateTimeStringVariable = Left(Format(%ITClock,%ITCompileTimePicture))
     #ENDIF
   #ENDIF
 #ENDIF
#!---------------------------------------------------------------------------------------
#EXTENSION(RifAddCompileDateTimeToVersion,'Add Compile Date/Time to version'),APPLICATION,REQ(RifVersionRes(RifVersionRes))
#!---------------------------------------------------------------------------------------
#PREPARE
  #!INSERT(%ITGlobalVars)
  #!SET(%ITTemplateName,'Add Compile Date/Time to version')
#ENDPREPARE
#!CALL(%ITInsertHeader)
#DISPLAY(),AT(,,,3)
#!
#BOXED('Rif mod to Icetips Version Extension')
#DISPLAY(''),AT(,,,3)
#PROMPT('Add Compile Date to version',CHECK),%ITVerAddDateToVersion,Default(%True),AT(10)
#ENABLE(%ITVerAddDateToVersion=%True)
#PROMPT('Format string for date',@s50),%ITVerAddDateToVersionFormat,Default('@d17')
#ENDENABLE
#PROMPT('Add Compile Time to version',CHECK),%ITVerAddTimeToVersion,Default(%True),AT(10)
#ENABLE(%ITVerAddTimeToVersion=%True)
#PROMPT('Format string for date',@s50),%ITVerAddDateTimeToVersionFormat,Default('@t04')
#ENDENABLE
#DISPLAY(''),AT(,,,3)
#ENDBOXED
#AT(%VerResourceValueList)
#DECLARE(%ITVerValueLine)
  #IF(%ITVerAddDateToVersion)
    #SET(%ITVerValueLine,'VALUE "Compile Date", "' & Format(Today(),%ITVerAddDateToVersionFormat) & '\0"')
        %ITVerValueLine
  #ENDIF
  #IF(%ITVerAddTimeToVersion)
    #SET(%ITVerValueLine,'VALUE "Compile Time", "' & Format(Clock(),%ITVerAddDateTimeToVersionFormat) & '\0"')
        %ITVerValueLine
  #ENDIF
#ENDAT
