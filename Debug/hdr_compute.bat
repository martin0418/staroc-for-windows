::配置FTP
set FTP=192.168.0.6
set FTPDownloadDir=.
set FTPUploadDir=result
::读取参数和初始化
set num=%1
set currentDir=%~dp0
set workDir=%currentDir%work
::清空上次工作目录
if exist %workDir% call :cleanWorkDirectory
mkdir %workDir%
::下载图像
cd %workDir%
call :setFTPDownloadScript
ftp -A -s:%d% %FTP%
::处理图像
set output=
if exist %workDir%\%num%_1.jpg set output=%output% %workDir%\%num%_1.jpg
if exist %workDir%\%num%_2.jpg set output=%output% %workDir%\%num%_2.jpg
if exist %workDir%\%num%_3.jpg set output=%output% %workDir%\%num%_3.jpg
call %currentDir%LuminanceHDR\luminance-hdr-cli.exe -o %workDir%\%num%_result.jpg -t fattal -q 80 %output%
::上传图像
call :setFTPUploadScript
ftp -A -s:%u% %FTP%
cd ..
::清空本次工作目录
:cleanWorkDirectory
rmdir /S /Q %workDir%
goto eof
:setFTPDownloadScript
set d=%workDir%\dScript.txt
echo cd %FTPDownloadDir% > %d%
echo get %num%_1.jpg >> %d%
echo get %num%_2.jpg >> %d%
echo get %num%_3.jpg >> %d%
echo bye >> %d%
:setFTPUploadScript
set u=%workDir%\uScript.txt
echo mkdir %FTPUploadDir% > %u%
echo cd %FTPUploadDir% >> %u%
echo put %num%_result.jpg >> %u%
echo bye >> %u%
:eof