-- Default Redirection for Clarion 11.0: 2021.12.08: Devuna {include ...}
-- Default Redirection for Clarion 10.0

[Copy]
-- Directories only used when copying dlls
-- RA.2021.11.18: Added second line for the specifc Devuna DLLs need
-- RA.2019.04.15: Added %BIN%\Debug to the front of the line
*.dll = %BIN%\Debug; %BIN%; %BIN%\AddIns\BackendBindings\ClarionBinding\Common; %ROOT%\Accessory\bin; %libpath%\bin\%configuration%
*.dll = C:\_GIT_\Devuna\__IDE__\BIN

-- Directories only used when building with Debug configuration
-- DEFAULT DIRECTORY SETUP --
--[Debug]
--*.obj = obj\debug
--*.res = obj\debug
--*.rsc = obj\debug
--*.lib = obj\debug
--*.FileList.xml = obj\debug
--*.map = map\debug

-- Directories only used when building with Release configuration
-- DEFAULT DIRECTORY SETUP --
--[Release]
--*.obj = obj\release
--*.res = obj\release
--*.rsc = obj\release
--*.lib = obj\release
--*.FileList.xml = obj\release
--*.map = map\release

[Common]
-- DEFAULT DIRECTORY SETUP --
-- RA.2019.12.01: ABC REPLACEMENT TEMPLATES AND CLASSES :RA.2019.12.01 ----
-- RA.2019.12.13: Temporary (.\classes\temp;) :RA.2019.12.13 ----
*.equ           = .\source;    .\classes; .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\LibSrc\win; %ROOT%\libsrc\win; %ROOT%\Accessory\libsrc\win;
*.clw           = .\source;    .\classes; .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\LibSrc\win; %ROOT%\libsrc\win; %ROOT%\Accessory\libsrc\win;
*.inc           = .\source; .; .\classes; .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\LibSrc\win; %ROOT%\examples; %ROOT%\libsrc; %ROOT%\images;  
*.shp           = .\source;
*.exp           = .\source;
*.lnk           = .\source;
*.RSC           = .\source; 
*.txs           = .\source;
*.map           = .\source;
*.obj           = .\source; %ROOT%\lib; %ROOT%\Accessory\lib
*.res           = .\source; %ROOT%\lib; %ROOT%\Accessory\lib
*.rsc           = .\source; %ROOT%\lib; %ROOT%\Accessory\lib
*.FileList.xml  = .\source;
*.cache         = .\source;
-- RA.2021.11.17: Version related files into one directory :RA.2021.11.17 --
-- RA.2019.12.05: Version related files into one directory :RA.2019.12.05 --
*.version       = .\version;
*.ver           = .\version;
*.vvr           = .\version;
-- RA.2019.12.07: SourceVelocity - VersionControl [.dct.BinaryImport, .app.BinaryImport] :RA.2019.12.07 --
*.apv           = .\vc_SV;
*.dcv           = .\vc_SV;
-- RA.2019.12.07: SourceVelocity - BACKUP :RA.2019.12.07 --
*.bpp           = .\backup;
*.bct           = .\backup;
-- RA.2020.04.15: Skype: Per Bruce Johnson. 
*.cwproj        = %ROOT%\Accessory\chromeExplorerProcess
--
-- RA.2018.02.21: RegFree requires the manifest and ocx to be in the Working directory
-- RA.2018.02.22: SkinFramework requires a Sytles directory where the exe is located
*.cjstyles      = .\Working\Styles;
*.manifest      = .\Working;
*.ocx           = .\Working; %BIN%; %ROOT%\Accessory\bin
*.dll           = .\Working; %BIN%; %ROOT%\Accessory\bin
*.exe           = .\Working; %BIN%; %ROOT%\Accessory\bin
--
*.lib           = .\lib; %ROOT%\lib; %ROOT%\Accessory\lib
*.inc           = %ROOT%\template; %ROOT%\convsrc; .\images; %ROOT%\Accessory\libsrc\win; 
-- RA.2019.12.01: ABC REPLACEMENT TEMPLATES AND CLASSES :RA.2019.12.01 ----
-- RA.2019.12.13: Temporary (.\classes\temp;) :RA.2019.12.13 ----
*.tp?           = .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\Template\win; %ROOT%\template\win; %ROOT%\Accessory\Template\Win
*.trf           = .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\Template\win; %ROOT%\template\win
*.txs           = .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\Template\win; %ROOT%\template\win
*.stt           = .\classes\temp; C:\_GIT_\RobertArtigas\ABC_Replace\Template\win; %ROOT%\template\win
*.tp?           = %ROOT%\Accessory\template\win
*.txs           = %ROOT%\Accessory\template\win
*.stt           = %ROOT%\Accessory\template\win
--
*.hlp           = %BIN%; %ROOT%\Accessory\bin
*.chm           = %BIN%; %ROOT%\Accessory\bin
-- catches everything else ---
-- RA.2019.12.07: .\IconSets\ico2 ADDED to the redirection file (2nd in search path)
-- RA.2018.02.20: .\IconSets\ico ADDED to the redirection file
*.*             = .; .\images; .\IconSets\ico; .\IconSets\ico2; %ROOT%\Accessory\Template\Win;%ROOT%\Accessory\LibSrc\Win;%ROOT%\Accessory\Images\Super
*.*             = .\cabinet; %ROOT%\libsrc\win; %ROOT%\images;%ROOT%\Accessory\Template\Win;%ROOT%\Accessory\LibSrc\Win;%ROOT%\Accessory\Images\Super
*.*             = %ROOT%\template\win; %ROOT%\Accessory\Template\Win; %ROOT%\Accessory\LibSrc\Win;
*.*             = %ROOT%\Accessory\Images\Super; %ROOT%\Accessory\Libsrc\win\jcl; %ROOT%\Accessory\images; 
*.*             = %ROOT%\Accessory\resources; %ROOT%\Accessory\libsrc\win; %ROOT%\Accessory\template\win

-- Clarion Directory Setup --
*.chm = %BIN%;%ROOT%\Accessory\bin
*.tp? = %ROOT%\template\win
*.trf = %ROOT%\template\win
*.txs = %ROOT%\template\win
*.stt = %ROOT%\template\win
*.*   = .; %ROOT%\libsrc\win; %ROOT%\images; %ROOT%\template\win
*.lib = %ROOT%\lib
*.obj = %ROOT%\lib
*.res = %ROOT%\lib
*.hlp = %BIN%;%ROOT%\Accessory\bin
*.dll = %BIN%;%ROOT%\Accessory\bin
*.exe = %BIN%;%ROOT%\Accessory\bin
*.tp? = %ROOT%\Accessory\template\win
*.txs = %ROOT%\Accessory\template\win
*.stt = %ROOT%\Accessory\template\win
*.lib = %ROOT%\Accessory\lib
*.obj = %ROOT%\Accessory\lib
*.res = %ROOT%\Accessory\lib
*.dll = %ROOT%\Accessory\bin
*.*   = %ROOT%\Accessory\images; %ROOT%\Accessory\resources; %ROOT%\Accessory\libsrc\win; %ROOT%\Accessory\template\win
--
-- DEVUNA, Roberto Artigas Devuna-ClassViewer, KiSS (Mark Riffey) development --
-- RA.2021.11.17.WED: It is working: Start setting up for GitHub download
-- RA.2021.09.13.MON: Start cleaning up this mess after I get it working
--        C:\_GIT_\Devuna\__IDE__\LibSrc\win
*.tpl   = C:\_GIT_\Devuna\__IDE__\Template\win;
*.tpw   = C:\_GIT_\Devuna\__IDE__\Template\win;
*.txt   = C:\_GIT_\Devuna\__IDE__\LibSrc\win;
*.C     = C:\_GIT_\Devuna\__IDE__\LibSrc\win;
*.inc   = C:\_GIT_\Devuna\__IDE__\LibSrc\win; C:\_GIT_\Devuna\__IDE__\Include\win;
*.int   = C:\_GIT_\Devuna\__IDE__\LibSrc\win;
*.clw   = C:\_GIT_\Devuna\__IDE__\LibSrc\win;
*.equ   = C:\_GIT_\Devuna\__IDE__\LibSrc\win;
*.def   = C:\_GIT_\Devuna\__IDE__\LibSrc\win;
*.gif   = C:\_GIT_\Devuna\__IDE__\Images;
*.bmp   = C:\_GIT_\Devuna\__IDE__\Images;
*.ico   = C:\_GIT_\Devuna\__IDE__\Images;
*.EXE   = C:\_GIT_\Devuna\__IDE__\BIN;
*.DLL   = C:\_GIT_\Devuna\__IDE__\BIN;
*.LIB   = C:\_GIT_\Devuna\__IDE__\LIB;
--
-- IGNORE WHAT COMES AFTER THIS --
-- IGNORE WHAT COMES AFTER THIS --
-- IGNORE WHAT COMES AFTER THIS --
-- 
-- RA.2020.08.14: Temporary generation (Can't find the registed template) :RA.2020.08.14 ----
*.tp?           = C:\_GIT_\RobertArtigas\DumpLoad\classes; C:\_GIT_\RobertArtigas\DumpLoad\classes\temp;
*.equ           = C:\_GIT_\RobertArtigas\DumpLoad\classes; C:\_GIT_\RobertArtigas\DumpLoad\classes\temp;
*.inc           = C:\_GIT_\RobertArtigas\DumpLoad\classes; C:\_GIT_\RobertArtigas\DumpLoad\classes\temp;
*.clw           = C:\_GIT_\RobertArtigas\DumpLoad\classes; C:\_GIT_\RobertArtigas\DumpLoad\classes\temp;
--
-- RA.2019.12.16: Temporary generation (Can't find the registed template) :RA.2019.12.16 ----
*.tp?           = C:\_GIT_\RobertArtigas\RES\Apps\classes; C:\_GIT_\RobertArtigas\RES\Apps\classes\temp;
*.equ           = C:\_GIT_\RobertArtigas\RES\Apps\classes; C:\_GIT_\RobertArtigas\RES\Apps\classes\temp;
*.inc           = C:\_GIT_\RobertArtigas\RES\Apps\classes; C:\_GIT_\RobertArtigas\RES\Apps\classes\temp;
*.clw           = C:\_GIT_\RobertArtigas\RES\Apps\classes; C:\_GIT_\RobertArtigas\RES\Apps\classes\temp;
--
-- RA.2021.02.10: C:\_GIT_\RobertArtigas\TheRat\Expose\Clarion\Apps\classes
*.clw           = C:\_GIT_\RobertArtigas\TheRat\Expose\Clarion\Apps\classes;
*.inc           = C:\_GIT_\RobertArtigas\TheRat\Expose\Clarion\Apps\classes;
*.equ           = C:\_GIT_\RobertArtigas\TheRat\Expose\Clarion\Apps\classes;
--
-- RA.2021.01.13: Get it working: C:\_GIT_\RobertArtigas\TheRat
*.tp?           = C:\_GIT_\RobertArtigas\TheRat\Template\win;
*.clw           = C:\_GIT_\RobertArtigas\TheRat\LibSrc\win;
*.inc           = C:\_GIT_\RobertArtigas\TheRat\LibSrc\win;
--
-- RA.2020.11.27: Get it working: C:\_GIT_\RobertArtigas\TD\Template\win
-- RA.2020.06.03: Setup the GIT repository with the TD templates/classes 
*.tp?           = C:\_GIT_\RobertArtigas\TD\Template\win;
*.clw           = C:\_GIT_\RobertArtigas\TD\LibSrc\win;
*.inc           = C:\_GIT_\RobertArtigas\TD\LibSrc\win;
--
-- RA.2019.10.27: Setup the GIT repository with the published templates
*.tp?           = C:\_GIT_\RobertArtigas\DUMPLOAD;
*.tp?           = C:\_GIT_\RobertArtigas\ROR_TPL;
*.tp?           = C:\_GIT_\RobertArtigas\DCT2SQL;
*.tp?           = C:\_GIT_\RobertArtigas\RYB;
*.tp?           = C:\_GIT_\RobertArtigas\DCT2CLASS;
*.tp?           = C:\_GIT_\RobertArtigas\XMLDOC;
--
-- RA.2021.12.30: RAYS became a hidden REPO for classes and templates that are being tested
-- before being moved to the public RYB repository. Got to HAND move the stuff.
*.tpl           = C:\_GIT_\RobertArtigas\RYB\win\Template;
*.tpw           = C:\_GIT_\RobertArtigas\RYB\win\Template;
*.int           = C:\_GIT_\RobertArtigas\RYB\win\LibSrc;
*.inc           = C:\_GIT_\RobertArtigas\RYB\win\LibSrc;
*.clw           = C:\_GIT_\RobertArtigas\RYB\win\LibSrc;
--
*.tpl           = C:\_GIT_\RobertArtigas\RAYS\win\Template;
*.tpw           = C:\_GIT_\RobertArtigas\RAYS\win\Template;
*.int           = C:\_GIT_\RobertArtigas\RAYS\win\LibSrc;
*.inc           = C:\_GIT_\RobertArtigas\RAYS\win\LibSrc;
*.clw           = C:\_GIT_\RobertArtigas\RAYS\win\LibSrc;
--
*.tpl           = C:\_GIT_\RobertArtigas\RAYS\hide\Template;
*.tpw           = C:\_GIT_\RobertArtigas\RAYS\hide\Template;
*.int           = C:\_GIT_\RobertArtigas\RAYS\hide\LibSrc;
*.inc           = C:\_GIT_\RobertArtigas\RAYS\hide\LibSrc;
*.clw           = C:\_GIT_\RobertArtigas\RAYS\hide\LibSrc;
--
-- CARL BARNES, CLARION WINDOWS PREVIEWER --
*.clw           = C:\_GIT_\CarlBarnes\LibSrc;
*.inc           = C:\_GIT_\CarlBarnes\LibSrc;
--
-- BO, UTILITY TEMPLATES --
*.gif = %ROOT%\Accessory\template\win\_BO_\BOTPL2;
*.ico = %ROOT%\Accessory\template\win\_BO_\BOTPL2;
*.tp? = %ROOT%\Accessory\template\win\_BO_\BOTPL2;
*.txs = %ROOT%\Accessory\template\win\_BO_\BOTPL2;
*.stt = %ROOT%\Accessory\template\win\_BO_\BOTPL2;
--
-- RYB, RUN YOUR BUSINESS --
*.gif = %ROOT%\Accessory\template\win\_RYB;
*.ico = %ROOT%\Accessory\template\win\_RYB;
*.tp? = %ROOT%\Accessory\template\win\_RYB;
*.txs = %ROOT%\Accessory\template\win\_RYB;
*.stt = %ROOT%\Accessory\template\win\_RYB;
*.in? = %ROOT%\Accessory\libsrc\win\_RYB;
*.clw = %ROOT%\Accessory\libsrc\win\_RYB;
*.equ = %ROOT%\Accessory\libsrc\win\_RYB;
*.txa = %ROOT%\Accessory\libsrc\win\_RYB;
--
-- MG, Mark Golberg --
-- Items from all the GIT repos --
*.gif = %ROOT%\Accessory\template\win\__MG;
*.ico = %ROOT%\Accessory\template\win\__MG;
*.tp? = %ROOT%\Accessory\template\win\__MG;
*.txs = %ROOT%\Accessory\template\win\__MG;
*.stt = %ROOT%\Accessory\template\win\__MG;
*.in? = %ROOT%\Accessory\libsrc\win\__MG;
*.clw = %ROOT%\Accessory\libsrc\win\__MG;
*.equ = %ROOT%\Accessory\libsrc\win\__MG;
*.txa = %ROOT%\Accessory\libsrc\win\__MG;
--
-- BOS, Breiner Non-Metalics --
*.gif = %ROOT%\Accessory\template\win\_BOS;
*.ico = %ROOT%\Accessory\template\win\_BOS;
*.tp? = %ROOT%\Accessory\template\win\_BOS;
*.txs = %ROOT%\Accessory\template\win\_BOS;
*.stt = %ROOT%\Accessory\template\win\_BOS;
*.in? = %ROOT%\Accessory\libsrc\win\_BOS;
*.clw = %ROOT%\Accessory\libsrc\win\_BOS;
*.equ = %ROOT%\Accessory\libsrc\win\_BOS;
*.txa = %ROOT%\Accessory\libsrc\win\_BOS;
--
-- RAYS, Roberto Artigas --
*.gif = %ROOT%\Accessory\template\win\_RAYS;
*.ico = %ROOT%\Accessory\template\win\_RAYS;
*.tp? = %ROOT%\Accessory\template\win\_RAYS;
*.txs = %ROOT%\Accessory\template\win\_RAYS;
*.stt = %ROOT%\Accessory\template\win\_RAYS;
*.in? = %ROOT%\Accessory\libsrc\win\_RAYS;
*.clw = %ROOT%\Accessory\libsrc\win\_RAYS;
*.equ = %ROOT%\Accessory\libsrc\win\_RAYS;
*.txa = %ROOT%\Accessory\libsrc\win\_RAYS;
--
-- _UDRA_, UD, Roberto Artigas VERSION (Before the 4 programmer code merge) --
-- RA.2018.02.24 - Need this for testing purposes
*.gif = %ROOT%\Accessory\template\win\_UDRA_;
*.ico = %ROOT%\Accessory\template\win\_UDRA_;
*.tp? = %ROOT%\Accessory\template\win\_UDRA_;
*.txs = %ROOT%\Accessory\template\win\_UDRA_;
*.stt = %ROOT%\Accessory\template\win\_UDRA_;
*.in? = %ROOT%\Accessory\libsrc\win\_UDRA_;
*.clw = %ROOT%\Accessory\libsrc\win\_UDRA_;
*.equ = %ROOT%\Accessory\libsrc\win\_UDRA_;
*.txa = %ROOT%\Accessory\libsrc\win\_UDRA_;
--
-- _TDRA_, TD, Roberto Artigas Threaded Debug (Replacement for UD) --
-- RA.2019.03.03 - Need this for testing purposes
*.gif = %ROOT%\Accessory\template\win\_TDRA_;
*.ico = %ROOT%\Accessory\template\win\_TDRA_;
*.tp? = %ROOT%\Accessory\template\win\_TDRA_;
*.txs = %ROOT%\Accessory\template\win\_TDRA_;
*.stt = %ROOT%\Accessory\template\win\_TDRA_;
*.in? = %ROOT%\Accessory\libsrc\win\_TDRA_;
*.clw = %ROOT%\Accessory\libsrc\win\_TDRA_;
*.equ = %ROOT%\Accessory\libsrc\win\_TDRA_;
*.txa = %ROOT%\Accessory\libsrc\win\_TDRA_;
--
-- _D2M2_, Roberto Artigas METABASE development --
--
*.gif = %ROOT%\Accessory\template\win\_D2M2_;
*.ico = %ROOT%\Accessory\template\win\_D2M2_;
*.tp? = %ROOT%\Accessory\template\win\_D2M2_;
*.tx? = %ROOT%\Accessory\template\win\_D2M2_;
*.stt = %ROOT%\Accessory\template\win\_D2M2_;
*.in? = %ROOT%\Accessory\libsrc\win\_D2M2_;
*.clw = %ROOT%\Accessory\libsrc\win\_D2M2_;
*.equ = %ROOT%\Accessory\libsrc\win\_D2M2_;
*.txa = %ROOT%\Accessory\libsrc\win\_D2M2_;
--
-- RA.2021.10.17.SUN: Export TXA templates (Using to fix corrupted APP)
*.tpl   = C:\_GIT_\MarkGoldberg\ClarionCommunity\CW\Templates
--
-- _UU_, ClarionLive ULTIMATE UTILITY PACK --
--
*.gif = %ROOT%\Accessory\template\win\_UU_;
*.ico = %ROOT%\Accessory\template\win\_UU_;
*.tpl = %ROOT%\Accessory\template\win\_UU_;
*.tpw = %ROOT%\Accessory\template\win\_UU_;
*.tx? = %ROOT%\Accessory\template\win\_UU_;
*.stt = %ROOT%\Accessory\template\win\_UU_;
*.inc = %ROOT%\Accessory\libsrc\win\_UU_;
*.int = %ROOT%\Accessory\libsrc\win\_UU_;
*.clw = %ROOT%\Accessory\libsrc\win\_UU_;
*.equ = %ROOT%\Accessory\libsrc\win\_UU_;
*.txa = %ROOT%\Accessory\libsrc\win\_UU_;
--
--
-- DEVUNA, Roberto Artigas Devuna-ClassViewer development --
--
-- Tools/Options/Clarion/Clarion for Windows/Versions Redirection File tab. 
-- CLASS_VIEWER = C:\_Clarion_Projects_\Devuna-ClassViewer;
--*.gif = %CLASS_VIEWER%\images; %CLASS_VIEWER%\template\win;
--*.ico = %CLASS_VIEWER%\images; %CLASS_VIEWER%\template\win;
--*.tp? = %CLASS_VIEWER%\template\win;
--*.tx? = %CLASS_VIEWER%\template\win;
--*.stt = %CLASS_VIEWER%\template\win;
--*.in? = %CLASS_VIEWER%\libsrc\win;
--*.clw = %CLASS_VIEWER%\libsrc\win;
--*.equ = %CLASS_VIEWER%\libsrc\win;
--*.tx? = %CLASS_VIEWER%\libsrc\win;
--*.EXE = %CLASS_VIEWER%\bin;
--*.DLL = %CLASS_VIEWER%\bin;
--*.LIB = %CLASS_VIEWER%\lib;
--*.SLN = %CLASS_VIEWER%\application;  
--
-- _SOFTRAGA_, Roberto Artigas Software by Ragazzi development --
--
*.tpl   = C:\_GIT_\RobertArtigas\SoftRaga\TEMPLATE;
*.tpw   = C:\_GIT_\RobertArtigas\SoftRaga\TEMPLATE;
*.txt   = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.C     = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.inc   = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.int   = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.clw   = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.equ   = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.def   = C:\_GIT_\RobertArtigas\SoftRaga\LibSrc;
*.EXE   = C:\_GIT_\RobertArtigas\SoftRaga\BIN;
*.DLL   = C:\_GIT_\RobertArtigas\SoftRaga\BIN;
*.LIB   = C:\_GIT_\RobertArtigas\SoftRaga\LIB;
*.png   = .\Images; C:\_GIT_\RobertArtigas\SoftRaga\Images;
*.gif   = .\Images; C:\_GIT_\RobertArtigas\SoftRaga\Images;
*.bmp   = .\Images; C:\_GIT_\RobertArtigas\SoftRaga\Images;
*.ico   = .\Images; C:\_GIT_\RobertArtigas\SoftRaga\Images;
*.cur   = .\Images; C:\_GIT_\RobertArtigas\SoftRaga\Images;

----------------------------------------------
-- RA.2021.04.06: Capesoft's ChromeExplorer --
-- Put here by the Capesoft Installer       --
----------------------------------------------
*.pak = %ROOT%\Accessory\bin
*.bin = %ROOT%\Accessory\bin
*.dat = %ROOT%\Accessory\bin
[AutoAdded]
*.pak=1
*.bin=1
*.dat=1
