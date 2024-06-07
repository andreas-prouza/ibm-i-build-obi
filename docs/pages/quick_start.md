# Quck Start

In general these are the steps to do:
1. Copy sources to IFS 
   * Change in RPG the /Copy- instruction to the IFS format
2. Add the build tool to your project folder  
   https://github.com/andreas-prouza/ibm-i-build-obi 
3. Setup SSH on your PC  
   https://github.com/andreas-prouza/ibm-i-build/blob/main/docs/pages/SSH.md 
4. Install Cygwin (for Windows)
5. Install Python (if you want full performance)
6. Edit the config files in etc/ directory (host name, remote IFS folder, …)
7. Create dependency list
8.  Install OBI on your IBM i (and PC)  
https://github.com/andreas-prouza/obi 
1. Create git repository
2.  Add content of your project folder into the git repository 

## Prerequesits on your IBM i

* ```rsync```
  
  ```yum install rsync```

* Python

  ```yum install python39 python39-pip python39-wheel python39-six python39-setuptools```

* [OBI](https://github.com/andreas-prouza/obi)


## Prerequesits on your PC

* ```rsync``` 
  
  ... is used to get sources synchroniced with your IBM i

  * For Windows:

    Since this is a Unix tool, you need to install Cygwin: https://cygwin.com/install.html

    Choose the ```rsync``` package during the setup

    ![cygwin-rsync](/docs/img/cygwin-rsync.png)

* GIT
  
  distributed version control system 

* [SSH key authentication](https://github.com/andreas-prouza/ibm-i-build/blob/main/docs/pages/SSH.md)

* IDE of your choice

  * Visual Studio Code (vscode)
    
    I am using the following extensions:
    
    You can use the exctension ID to find the correct one

    * Even Better TOML (tamasfe.even-better-toml)
    * Command Runner (edonet.vscode-command-runner)
    * Git Graph (mhutchie.git-graph)
    * GitLens (eamodio.gitlens)
    * IBM i Development Pack (halcyontechltd.ibm-i-development-pack)
    * Markdown All in One (yzhang.markdown-all-in-one)
    * VsCode Action Buttons (seunlanlege.action-buttons)
  * Rational Developer for i (RDi)


### Optional (recommended) prerequesits

* [OBI](https://github.com/andreas-prouza/obi)
  
  If you want create the build list directly on your local PC, you also need [OBI](https://github.com/andreas-prouza/obi).

  This is usually much fastern, than doing this on your IBM i.

  Have a short look into the documentation of OBI for setup instructions.

* Python

  If OBI is used on a local PC, Python must be installed.


## Start setup

1. Download this project to a location on your PC

   You can use the git command:
   
   ```sh
   C:\Users\Andreas\Documents\projects>git clone https://github.com/andreas-prouza/ibm-i-build-obi.git
   Cloning into 'ibm-i-build-obi'...
   remote: Enumerating objects: 211, done.
   remote: Counting objects: 100% (211/211), done.
   remote: Compressing objects: 100% (133/133), done.
   Receiving objects: 100% (211/211), 68.49 KiB | 1.09 MiB/s, done.d 0

   Resolving deltas: 100% (101/101), done.
   ```

2. Settings in your IDE
   * VSCode
     * When you open the directory in vscode you may only see the following content:
       
       ![vscode-content](/docs/img/vscode-content.png)
       
       Some folders are hidden because they are potentially annoying:

       ![explorer-content](/docs/img/explorer-content.png)

     * Choose correct settings
       
       * If you are using Cygwin, copy the content of ```.vscode/windows.cygwin.settings.json``` into ```.vscode/settings.json```.<br/>
        It's recommended to restart vscode after this, to get all settings in action.

3. Configure ```etc/global.cfg```
   
   This config contains global system settings which are used for the shell scripts.
   <br/>
   Important settings to check:
   
   * ```USE_PYTHON``` 
     * ```true```: Use local OBI to generate the build script
     * ```false``` (default): Use IBM i to generate the build script
   
   * ```OBI_DIR```
      
      If ```USE_PYTHON``` is ```true```, set the path to your local OBI directory. <br/>
      You can use the ```$WORKSPACE_FOLDER``` variable, if the path in relative to your project location.<br\>
      E.g.: (default) ```OBI_DIR=$WORKSPACE_FOLDER/../obi```
   
   * ```REMOTE_HOST```
     
     Should be the same name, which you are using in ```~/.ssh/config``` (see [SSH user configuration](https://github.com/andreas-prouza/ibm-i-build/blob/main/docs/pages/SSH.md)).
   
   * ```REMOTE_WORKSPACE_FOLDER_NAME```
     
     Project location on your IBM i for source synchronization.<br/>
     E.g. (default) ```REMOTE_WORKSPACE_FOLDER_NAME="~/$WORKSPACE_FOLDER_NAME"```
   
   * ```REMOTE_OBI_DIR```
     
     IFS location of OBI on your IBM i
  
4. Configure ```etc/app-config.toml```

   This config is used by OBI.
   <br/>
   It contains settings to generate the build list/commands and the execution of the build

   * In section ```[general]```:

     * ```file-system-encoding```
       
       Default: ```utf-8```
       <br/>
       On windows you may need to use ```cp1252``` if special characters in file name are not correct shown.
       <br/>
       (Specially for characters like the paragraph: ```§```)

     * ```remote-base-dir```
       
       Again the remote directory. This one is used by OBI to generate the correct build command for the IBM i.

   * In section ```[global.settings.general]```:

     There you can change some default compile parameters (like ACTGRP, TGTRLS, DBGVIEW, ...)

     * ```INCDIR_SQLRPGLE``` and ```INCDIR_RPGLE```
       
       Path list to search for ```/copy``` or ```/include``` directives in RPG sources.

       It's necessary to adapt these settings, if you want to add sources of other libraries.
       
       ```INCDIR_SQLRPGLE``` is used for SQLRPGLE sources
       <br/>
       ```INCDIR_RPGLE``` is used for PGLE sources

       For more information see ...
       * [/COPY or /INCLUDE](https://www.ibm.com/docs/en/i/7.5?topic=directives-copy-include)
       * [Search Path Within The IFS](https://www.ibm.com/docs/en/i/7.5?topic=files-search-path-within-ifs)

     * ```TARGET_LIB_MAPPING```

       Here you can make a mapping for your target lib.
       <br/>
       This is usually used if you want to compile in your development library instead of production library.

5. Make a test
   
   ![show-changes](/docs/img/vscode-show-changes.png)

   You may have noticed the original library is ```prouzalib``` but the object name in the ```CRTBNDCL``` command is ```prouzat1```.
   <br/>
   This is due to the ```TARGET_LIB_MAPPING``` setting mentioned previously.

6. If everything meets your expectation you can start to run your builds