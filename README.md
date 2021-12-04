# DEVUNA__IDE__
DEVUNA directory arranged as a Clarion IDE set of directories. What has been done, is a compile of the existing sources using 
the RED file provided that points to the LibSrc and Template directories for these specific applications. Everything is issolated 
in it's own directories so you do not have to add all the DEVUNA classes and templates into your common Clarion directories.

The KiSS application directory is Mr. Mark Riffey's sources with all his changes. The Class Viewer application directory 
is currently the sources from the DEVUNA directory (there will be some changes later).

If you need the original sources to start with, download the current directory structure, get it to compile. Then get the original sources 
from the DEVUNA directories, put it in the correct place for your specific compile directory structure, and then do your compiles.

## Compile directory path

Disk Drive Compiler Directory Path: **C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\\***

That above location is the compile directory path that is being used to compile the applications on the disk drive.<br/><br/><br/>   


![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_DIRECTORY_01.PNG)
<BR/>Above you are viewing the directory structure of the GitHub directory on my development machine.<br/><br/><br/>


![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_DIRECTORY_02.PNG)
<BR/>Once you move into the application directory you will see the different application that are currently available.<br/><br/><br/>


![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_DIRECTORY_03.PNG)
<BR/>In each application directory there is a local RED file that will be picked up by the IDE when you open the application.<br/><br/><br/>

## [RED]irection file

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_01.PNG)
<BR/>Using the KSS application as an example I opened the RED file from the IDE and you can see that all there is an include the specfic RED file 
that is being used.<br/><br/><br/>


![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_02.PNG)
<BR/>The entries that are used by the IDE that apply to the Devuna locations are shown above. They point to were the class sources and templates are located
so when the IDE opens it can find classes and templates. Please recall that you still have to regiter the templates from the specific directory location.

If you want to use your personal RED file, the entries will have to be copied from this RED to your RED, and your RED directory locations changed 
for your Clarion IDE setup to where you have located your Devuna directories.<br/><br/><br/>




You might have to adjust the RED file being used for your specific compile paths. 
