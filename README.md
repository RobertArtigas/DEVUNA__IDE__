<H3>Before you decide to do this installation, at least read the documentaton written below. 
This is NOT a download or clone, and then compile and run.
You will need to have some understanding of the compile directory structure, make some modifications to your RED file, 
and when you compile, you will need to resolve any issues that just might happen with the other installed software you have.
</H3>
<H3>What this series of steps will get you once completed, is an evironment that will allow you to compile, modify and run some of the DEVUNA tools.
And you will have spent considerable less time in doing this, than taking all the original DEVUNA GitHub repositories, and figuring out the
process from scratch.
</H3>
<H3>There have been a few individuals that have downloaded this repository and got it running. Their testing has been very helpful.
Some of the documentation has been enhanced because of these efforts.
And through the generosity of these individuals, I have received additional RED files that you can inspect as examples of environment setups.
</H3>
<H3>Any enhancements or changes to any part of the original source code, that you decide to make public for use by others, 
should be submited back to Mr. Randy Rogers at the GitHub https://github.com/Devuna website, by whichever mechanism or procedure that he has defined.
</H3>
<H3>After reading the documentation, send e-mail questions to this address.<br/>roberto.artigas.dev@gmail.com</H3>
<br/><br/>

# Drive:\RootFolder\DEVUNA__IDE__\\*

**DEVUNA directory arranged as a Clarion IDE set of directories.** What has been done, is a compile of the existing sources using 
the **RED** file provided that points to the **LibSrc** and **Template** directories for these specific applications. Everything is issolated 
in it's own directories so you do not have to add all the [DEVUNA](https://github.com/Devuna) classes and templates into your common Clarion directories.

**IMPORTANT IMPORTANT IMPORTANT -->** These separate directories get merged into your IDE environment. This means these directories will have to be in any other RED files that you use in other projects. When you bring up another project that uses a different RED and you find these templates missing, 
you will need to add the directory entries of your DEVUNA project to this specific RED file.

If you rather not have this type of split directory environment, just put all the correct directories into your **standard Clarion enviroment** locations (as Mr. Mark Riffey did), set up your compile project directory as you normally would, and go make the changes you want. **<-- IMPORTANT IMPORTANT IMPORTANT** 

<br/>
<H3>This is my personal directory with changes to the original applications for the executable versions that are used in my Clarion development.
These are NOT the original sources.</H3>
<br/><br/>

The KSS application directory is Mr. Mark Riffey's sources with all his changes. The Class Viewer application directory 
is currently the sources from the DEVUNA directory with some version enhancements and code refactoring. 
If you want to see what has been done, then download the sources and look at them. Compare them to the original.
See if you want to use this specific version.

If you need the original sources to start with, download the current directory structure, get it to compile. Then get the original sources 
from the [DEVUNA](https://github.com/Devuna) directories, put it in the correct place for your specific compile directory structure, and then do your compiles.

This will get you started compiling some of the sources with a minimal amount of effort. A lot less effort that it took for 
[Mr. Mark Riffey](https://github.com/mriffey/Devuna-KwikSourceSearch) or [I](https://github.com/RobertArtigas/DEVUNA__IDE__), to get our versions running from the original sources.

<br/>
<H3>May you have good fortune with all your learning experiences.
<H3> 
<br/><br/>

## Additional Requirements
 
You will need the Capesoft **StringTheory**, **WinEvent** and **xFiles** templates, since they are part of the KSS search utility.

It has been **reported** that some icetips templates might be needed for KSS at this time. [Looking into this ???]
 
I personally own the icetips, capesoft, superstuff, and other vendor templates. 
So this was not a missing set of items for myself and the additional individuals that tested.
The positble requirements reported missing are now documented. The specifics templates are not, but if you do not have them, 
they can can be removed by the IDE and you will have to deal with the funtionality that **might be missing.** <br/>
 
The ABCVIEW class viewer untility should not have any additional vendor requirements. <br/>
 
**Your mileage may vary depending on other vendor's templates you use.**
 
<br/><br/>

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
<BR/>In each application directory there is a local **RED** file that will be picked up by the **IDE** when you open the application.
This is the specific **KSS** aplication directory.<br/><br/><br/>

## [RED]irection file

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_01.PNG)
<BR/>Using the **KSS** application as an example I opened the **RED** file from the **IDE** and you can see that all there is an include the specfic **RED** file 
that is being used.

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_MR_01.PNG)
**Please recall that you will need to change the _C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\BIN\\*.RED_ file entry to that you are using to the _Drive:\\RootFolder\\DEVUNA\_\_IDE\_\_\\BIN\\*.RED_ that matches your directory structure.**
<br/><br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_02.PNG)
<BR/>**The RED entries that are used by the IDE that apply to the Devuna locations for my directory setup are shown above.** 
They point to were the class sources and templates are located so when the **IDE** opens it can find classes and templates. 
Please recall that you still have to register the templates from the specific directory location.
 
If you want to use your personal **RED** file, the entries will have to be copied from this **RED** file to your **RED** file, and your **RED** file directory locations changed 
for your Clarion **IDE** setup to where you have located your Devuna directories.

_There may be a couple of additional entries need in your **RED** file to pick up the images that are for each application that are location in
each specific image directory for that application._
 
 </br></br>
 
![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RED_MR_02.PNG)
**Please recall that you will need to change the _C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\*_ REDirection entries to that you are using to the _Drive:\\RootFolder\\DEVUNA\_\_IDE\_\_\\*_ format that matches your directory structure.**
<br/><br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\Template\\win

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_TEMPLATE_01.PNG)
<br/>
<H3>Do not forget to register these templates at the directory location that you have put them in. 
 If your RED file is set up correctly they will be picked up when you re-start the IDE or load a new application for modification.</H3>
 </br></br>
 
## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\LibSrc\\win

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_LIBSRC_01.PNG)
<br/>**If you do not have them installed in your LibSrc already,** you might need to add Mark Goldberg's debuger class 
and additional source files in your **LibSrc** directory. They are _debuger.inc, debuger.clw, TUFO.int, and FileAccessModes.EQU._ 
They are included in the **LibSrc** directory with _underscores_ in case you do not have them. 
A simple removal of the _underscores_ will get you those files. You can also get the files from the **GiHub** repository at 
https://github.com/MarkGoldberg/ClarionCommunity/tree/master/CW/Shared/Src where those files are located.

The debuger class is used in the _csciviewer.inc, and csciviewer.clw._ That class is used in the Class Viewer utility, and the relevant debuger code items 
in those two class files have been commented out.
<br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\RunTime\\

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RUNTIME_01.PNG)
<br/>This contains the **RunTime** environment directories for each utility with all the necessary files to
be able to run the utility. ~~After compiling the utility and getting a clean compile, move the **EXE** to the appropriate utility 
**RunTime** directory and you should be able to test.~~
<br/>
The projects have been changed to compile directly to the **Runtime** directories. Once compiled, you can run the **EXE** from that location.
It is probably useful to setup the applications as pinned to the taskbar when you run them the first time.
<br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RUNTIME_02.PNG)
<br/>This is the run time environment for the Class Viewer utility.
<br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_RUNTIME_03.PNG)
<br/>This is the run time environment for the Source Search utility.
<br/><br/><br/>

## C:\\\_GIT\_\\Devuna\\\_\_IDE\_\_\\Application\\KSS (POSSIBLE COMPILE ERRORS)

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_01.png)
![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_02.png)
<br/>If your get the **Unknown identifier** error messages above when you compile, uncomment the two lines with the identifier definitions
and you should be good to recompile. Some installations have those items already defined and you will get **duplicate** definitions.
<br/><br/>

![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_03.png)
![A](https://github.com/RobertArtigas/DEVUNA__IDE__/blob/main/wiki/Images/DEVUNA_KSS_ER_04.png)
<br/>If you have this error, **delete kss.res** from the _**Libraries, Objects and Resource Files**_ list.
Be aware, if you setup from this repository you will not need **kss.res.** I am not aware, if it is needed, or not needed in the original sources compile.
<br/><br/><br/>

## Webinars explaining this GitHub repository

ClarionLive : 644 : Jan 21, 2022 : https://www.youtube.com/watch?v=ZZDxJDUnoRc

Clarioneros : 212 : 2022-01-29 : https://clarionlive.com/clarioneros.htm (**OneDrive** link)
##
###

**I didn’t like all this mystery** business long before I ever did anything about it, and when I _did_ do something about it, I found that I was right, that all mystery is in the eye of the beholder and that we are free to stop seeing mystery whenever we decide to open our eyes and actually look. This is no small point. We have to look hard at this mystery business in order to get past it.<br/> 
_-Jed McKenna’s Theory of Everything: The Enlightened Perspective_

<!-- C:\_GIT_\Devuna\__IDE__\BIN\VersionMe.exe PROJECT=$(OutputName) BINARYTYPE=$(OutputType) APPFOLDER=$(SolutionDir) -->

##

[Code](https://github.com/RobertArtigas/DEVUNA__IDE__) 
[Wiki](https://github.com/RobertArtigas/DEVUNA__IDE__/wiki) 
[Main](https://github.com/RobertArtigas) 
[Repositories](https://github.com/RobertArtigas?tab=repositories)

