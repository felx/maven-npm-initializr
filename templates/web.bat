@echo off
set NODE_HOME=%cd%\src\web\node_modules\.node\node
PATH=%cd%\src\web\node_modules\.bin;%NODE_HOME%;%PATH%
echo using
echo node
node --version
echo npm
cmd /c npm -version
REM cmd /c ? lol : https://github.com/npm/npm/issues/2938 (status : (!) opened since Nov 10, 2012, GFY!)
cd src\web