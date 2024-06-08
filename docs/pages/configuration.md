# Configuration

All configurations are located in ```etc/```.


## ```etc/app-config.toml```

It contains global and compile settings.

### Most important configurations here are:

* ```general.local-base-dir```  
  project directory on your local PC
* ```general.remote-base-dir```  
  Remote IFS directory on your IBM i (for building the sources)
* In section ```global.settings.general```:
  * ```INCLUDE_BNDDIR```
  * ```INCDIR_RPGLE``` / ```INCDIR_SQLRPGLE```
    * For more information see ...
       * [/COPY or /INCLUDE](https://www.ibm.com/docs/en/i/7.5?topic=directives-copy-include)
       * [Search Path Within The IFS](https://www.ibm.com/docs/en/i/7.5?topic=files-search-path-within-ifs)
  * ```LIBL```  
    Used LIBL when running build commands
  * ```ACTGRP```
  * ```TARGET_LIB_MAPPING```  
    Here you can make a mapping for your target lib.  
    This is usually used if you want to compile in your development library instead of production library.


### Compile commands

In section ```global.steps``` you can define a list of steps (commands) to be executed for each source type.

Each step/command is a full qualified variable in the toml file.  
Each command variable contains a command string which will be executed in pase (bash).

So you can also define your own shell commands for using as a step for a source type.


## ```etc/dependency.toml```

Here all objects depending on other objects are defined.

Example:  
The display file ```invoice.dspf.file``` is used in ```invoice1.rpgle.pgm``` and ```invoice2.rpgle.pgm```.  
The definition would looks like the following:
```bash
"prouzalib/qrpglesrc/invoice1.rpgle.pgm" = ["prouzalib/qddssrc/invoice.dspf.file"]
"prouzalib/qrpglesrc/invoice2.rpgle.pgm" = ["prouzalib/qddssrc/invoice.dspf.file"]
```

You should use a program/script to automatically generate this file periodically.


## ```etc/object-builds.toml```

In this toml file all compiled objects will be listed with timestamp and hash value of the source.

[OBI](https://github.com/andreas-prouza/obi) generates hash values of each sources and compairs it with the hash value of the source in the ```object-builds.toml``` file.  
New sources will be compiled anyway.


## ```etc/global.cfg```

This config will be used by the shell scripts located in ```scripts/```.

Here the most important variables you should change:

* ```CLIENT_TYPE```  
  This is to identify if the scripts run on the IBM i server or on your local PC.  
  (E.g. it's not necessary to sync sources to the IBM i if it is already there.)
* ```USE_PYTHON```  
  Use [OBI](https://github.com/andreas-prouza/obi) (for generating the compile list) either on your local PC (very fast) or on IBM i (performance hardly depends on your machine)
     * ```true```: Use local OBI to generate the build script
     * ```false```: Use IBM i to generate the build script
* ```OBI_DIR```  
  Path to OBI on your local PC
* ```REMOTE_HOST```  
  IP or hostname of your IBM i (SSH)
* ```REMOTE_WORKSPACE_FOLDER_NAME```  
  IFS directory where the project will be synchronised
* ```REMOTE_OBI_DIR```  
  IFS directory of OBI on your IBM i.


## ```etc/.user.cfg```

In this file you are able to override settings from ```etc/global.cfg```.  
This file shouldn't get saved in the git repository. That's the reason why it is written to the .gitignore list.

This file should be used for each developer to define his own environment settings.