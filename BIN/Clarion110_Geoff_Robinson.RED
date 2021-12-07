-- Default Redirection for Clarion 11.0

[Copy]
-- Directories only used when copying dlls
*.dll = %BIN%;%BIN%\AddIns\BackendBindings\ClarionBinding\Common;%ROOT%\Accessory\bin;%libpath%\bin\%configuration%;%ROOT%\Devuna\bin

[Debug]
-- Directories only used when building with Debug configuration
-- see: https://clarionhub.com/t/editing-default-redirection-red-file-to-create-lib-with-dll-in-project-folder/1646/5

*.obj = c:\tempobj
*.$$$ = c:\tempobj
*.res = c:\tempobj
*.rsc = c:\tempobj
*.lib = .
*.dll = .
*.exe = .
*.FileList.xml = c:\tempobj
*.map = c:\tempobj
*.bat = .

[Release]
-- Directories only used when building with Release configuration

*.$$$ = c:\tempobj
*.obj = c:\tempobj
*.res = c:\tempobj
*.rsc = c:\tempobj
*.lib = .
*.dll = .
*.exe = .
*.FileList.xml = c:\tempobj
*.map = c:\tempobj
*.bat = .

[Common]
*.chm = %BIN%;%ROOT%\Accessory\bin;%ROOT%\Devuna\bin
*.tp? = %ROOT%\template\win;%ROOT%\Accessory\template\win;%ROOT%\Devuna\template\win
*.trf = %ROOT%\template\win
*.txs = %ROOT%\template\win
*.stt = %ROOT%\template\win
*.lib = %ROOT%\lib;%ROOT%\Accessory\lib;%ROOT%\Devuna\lib
*.obj = %ROOT%\lib;%ROOT%\Accessory\lib;%ROOT%\Devuna\lib
*.res = %ROOT%\lib
*.hlp = %BIN%;%ROOT%\Accessory\bin;%ROOT%\Devuna\bin
*.dll = %BIN%;%ROOT%\Accessory\bin;%ROOT%\Devuna\bin
*.exe = %BIN%;%ROOT%\Accessory\bin;%ROOT%\Devuna\bin
*.txs = %ROOT%\Accessory\template\win;%ROOT%\Devuna\template\win
*.stt = %ROOT%\Accessory\template\win;%ROOT%\Devuna\template\win
*.res = %ROOT%\Accessory\lib;%ROOT%\Devuna\lib
*.*   = .; %ROOT%\libsrc\win; %ROOT%\images; %ROOT%\template\win; %ROOT%\Accessory\images; %ROOT%\Accessory\resources; %ROOT%\Accessory\libsrc\win; %ROOT%\Accessory\template\win; %ROOT%\Devuna\images; %ROOT%\Devuna\resources; %ROOT%\Devuna\libsrc\win; %ROOT%\Devuna\template\win;.\Images
