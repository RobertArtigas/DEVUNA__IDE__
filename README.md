# Drive:\RootFolder\DEVUNA__IDE__\\*

**DEVUNA directory arranged as a Clarion IDE set of directories.** What has been done, is a compile of the existing sources using 
the RED file provided that points to the LibSrc and Template directories for these specific applications. Everything is issolated 
in it's own directories so you do not have to add all the [DEVUNA](https://github.com/Devuna) classes and templates into your common Clarion directories.

The KSS application directory is Mr. Mark Riffey's sources with all his changes. The Class Viewer application directory 
is currently the sources from the DEVUNA directory (there will be some changes later). 

<br/>_**This is my personal directory with changes to the original applications for the executable versions are used in my Clarion development.<br/><br/>
These are NOT the original sources.**_<br/><br/>

If you need the original sources to start with, download the current directory structure, get it to compile. Then get the original sources 
from the [DEVUNA](https://github.com/Devuna) directories, put it in the correct place for your specific compile directory structure, and then do your compiles.

This will get you started compiling some of the sources with a minimal amount of effort. A lot less effort that it took for [Mr. Mark Riffey](https://github.com/mriffey/Devuna-KwikSourceSearch) to get his version runing from the original sources.

<H3>Any enhancements or changes to any part of the original source code, that you decide to make public for use by others, should be submited back to Mr. Randy Rogers at the GitHub https://github.com/Devuna website, by whichever mechanism or procedure that he has defined.</H3>

May you have good fortune with all your learning experiences.

## Compile directory path

My disk drive compiler directory path: **C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\\***

That above location is the compile directory path that is being used to compile the applications on my disk drive.
All the references showing in the documentation will be based on that compiler directory structure.

Your disk drive compiler directory path: **Drive:\\RootFolder\\DEVUNA\_\_IDE\_\_\\\***

When you press the **Code** button and unzip the structure, or you clone into your directory your directory will match your structure above
and you will have to change some of your references to the directory structures to match your specific directory location choice.  
<br/><br/><br/>   

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_
![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_DIRECTORY_01.PNG)
<BR/>Above you are viewing the directory structure of the GitHub directory on my development machine.<br/><br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\Application
![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_DIRECTORY_02.PNG)
<BR/>Once you move into the application directory you will see the different applications that are currently available.<br/><br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\Application\\KSS
![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_DIRECTORY_03.PNG)
<BR/>In each application directory there is a local RED file that will be picked up by the IDE when you open the application.
This is the specific KSS aplication directory.<br/><br/><br/>

## [RED]irection file

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_01.PNG)
<BR/>Using the KSS application as an example I opened the RED file from the IDE and you can see that all there is an include the specfic RED file 
that is being used.

**Please recall that you will need to change the _C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\BIN\\*.RED_ file entry to that you are using to the _Drive:\\\_RootFolder\_\\DEVUNA\_\_IDE\_\_\\BIN\\*.RED_ that matches your directory structure.**
<br/><br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_02.PNG)
<BR/>**The RED entries that are used by the IDE that apply to the Devuna locations for my directory setup are shown above.** 
They point to were the class sources and templates are located so when the IDE opens it can find classes and templates. 
Please recall that you still have to register the templates from the specific directory location.

If you want to use your personal RED file, the entries will have to be copied from this RED file to your RED file, and your RED file directory locations changed 
for your Clarion IDE setup to where you have located your Devuna directories.

_There may be a couple of additional entries need in your RED file to pick up the images that are for each application that are location in
each specific image directory for that application._

**Please recall that you will need to change the _C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\*_ REDirection entries to that you are using to the _Drive:\\\_RootFolder\_\\DEVUNA\_\_IDE\_\_\\*_ format that matches your directory structure.**
<br/><br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\Template\\win

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_TEMPLATE_01.PNG)
<br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\LibSrc\\win

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_LIBSRC_01.PNG)
<br/>**If you do not have them installed in your LibSrc already,** you will need to add Mark Goldberg's debuger class and additional source files in your **LibSrc** directory. They are _debuger.inc, debuger.clw, TUFO.int, and FileAccessModes.EQU._ They are included in the **LibSrc** directory with an underscore in case you do not have them. A simple removal of the underscore will get you those files. You can also get the files from the **GiHub** repository at 
https://github.com/MarkGoldberg/ClarionCommunity/tree/master/CW/Shared/Src where those files are located.

The debuger class is used in the _csviewer.inc, and csviewer.clw._ That class is used in the Class Viewer utility, and the relevant debuger code items 
in those two class files have been commented out.
<br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\RunTime\\

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RUNTIME_01.PNG)
<br/>This contains the RunTime environment directories for each utility with all the necessary files to
be able to run the utility. After compiling the utility and getting a clean compile, move the EXE the appropriate utility 
directory and you should be able to test.
<br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RUNTIME_02.PNG)
<br/>This is the run time environment for the Class Viewer utility.
<br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RUNTIME_03.PNG)
<br/>This is the run time environment for the Source Search utility.
<br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\Application\\KSS (Posible compile errors)

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_01.png)

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_02.png)
<br/>If your get the **Unknown identifier** error messages above, uncomment the two lines with the identifier definitions
and you should be good to go. Some installations have those items already defined and you will get duplicate definitions.
<br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_03.png)

<br/><br/><br/>

## Webinars explaining this GitHub repository

Nothing yet

##
###

**I didn’t like all this mystery** business long before I ever did anything about it, and when I _did_ do something about it, I found that I was right, that all mystery is in the eye of the beholder and that we are free to stop seeing mystery whenever we decide to open our eyes and actually look. This is no small point. We have to look hard at this mystery business in order to get past it.<br/> 
_-Jed McKenna’s Theory of Everything: The Enlightened Perspective_

##

[Code](https://github.com/RobertArtigas/DEVUNA__IDE__) 
[Wiki](https://github.com/RobertArtigas/DEVUNA__IDE__/wiki) 
[Main](https://github.com/RobertArtigas) 
[Repositories](https://github.com/RobertArtigas?tab=repositories)

