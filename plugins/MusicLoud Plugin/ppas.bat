@echo off
C:\Lazarus\fpc\2.2.4\bin\i386-win32\windres.exe --include C:/Lazarus/fpc/222A9D~1.4/bin/I386-W~1/ -O res -o "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\project1.res" C:/Spiele/LAZARU~1/TECHNO~2/MUSICL~1/MUSICL~1/project1.rc --preprocessor=C:\Lazarus\fpc\2.2.4\bin\i386-win32\cpp.exe
if errorlevel 1 goto linkend
SET THEFILE=C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\project1.dll
echo Linking %THEFILE%
C:\Lazarus\fpc\2.2.4\bin\i386-win32\ld.exe -b pe-i386 -m i386pe  --gc-sections  -s --dll  --entry _DLLMainCRTStartup   --base-file base.$$$ -o "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\project1.dll" "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\link.res"
if errorlevel 1 goto linkend
C:\Lazarus\fpc\2.2.4\bin\i386-win32\dlltool.exe -S C:\Lazarus\fpc\2.2.4\bin\i386-win32\as.exe -D "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\project1.dll" -e exp.$$$ --base-file base.$$$ 
if errorlevel 1 goto linkend
C:\Lazarus\fpc\2.2.4\bin\i386-win32\ld.exe -b pe-i386 -m i386pe  -s --dll  --entry _DLLMainCRTStartup   -o "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\project1.dll" "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\link.res" exp.$$$
if errorlevel 1 goto linkend
C:\Lazarus\fpc\2.2.4\bin\i386-win32\postw32.exe --subsystem console --input "C:\Spiele\Lazarus_Projects\Technobase Player Plugins\MusicLoud Plugin\MusicLoud Plugin\project1.dll" --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
