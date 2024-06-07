# About the concept

2-part concept
* IDE integration → IBM i build with OBI  
  https://github.com/andreas-prouza/ibm-i-build-obi
* Build-Service → OBI  
  https://github.com/andreas-prouza/obi


![source-list](/docs/img/2-part-concept.png)


## Object Builder for i (OBI)

This is a backend processing tool.  
It ...  
* generates the compile list
* runs the build
* creates a summary report

This tool needs to be installed on you IBM i.

OBI is supposed to be independed by any project.  
Means you can reuse the single OBI setup for different projects.



## IDE integration (IBM i Build with OBI)

This is the "cockpit".  
It manages the communication between OBI and your IDE

Every task will be done by a bash script (located in ```scripts/```).  
If you choose an IDE you need to find a way to easily execute them.

* In RDi  
  You can define the scripts in ```External Tools```  
  ![RDi](/docs/img/rdi-actions.png)
* In VSCode  
  You can use plugins to get them executed (e.g. ```Action Buttons```)
  ![vscode-buttons](/docs/img/vscode-actions.png)

Your sources are located here in ```src/```.

It also provides necessary configurations to OBI for building process.  
(```etc/app-config.toml```, ```etc/dependency.toml```, ...)

## The process step by step

![source-list](/docs/img/obi-steps.png)

1. [OBI](https://github.com/andreas-prouza/obi) is looking for changed sources  
   The source hash value will be compared with the value stored (from last build) in ```etc/object-builds.toml```
2. [OBI](https://github.com/andreas-prouza/obi) generates a compile list (```build-output/compile-list.json```)
3. [IBM i Build with OBI](https://github.com/andreas-prouza/ibm-i-build-obi) synchronise all sources to IBM i  
   Every developer should have his own build directory (usually somewhere in ```/home/$USER```)
4. [OBI](https://github.com/andreas-prouza/obi) runs the generated build from ```build-output/compile-list.json```
5. At the end [IBM i Build with OBI](https://github.com/andreas-prouza/ibm-i-build-obi) gets all logs and the report summary