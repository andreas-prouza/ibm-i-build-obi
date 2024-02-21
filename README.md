# Object Builder for i (OBI)

## [Quick Start](/docs/pages/quick_start.md)

[Here](/docs/pages/quick_start.md) you can jump direktly to the installation instructions.

## Features

* Free of charge
  
  Except for RDi, all components used in this tool are free of charge

* Check for changes
  
  It checks all sources which have changed since last compilie
  
* Check for dependencies
  
  All objects which depend on the changed source will also be compiled (in correct order)

  E.g. if a table or view has changed, all objects which use them will be compiled too

* Compile in correct order
  
  tables before programs etc. based on the dependency list

* All actions can be done in you IDE (RDi or vscode)
  * Using short cuts

    ![run-command-2.jpg](docs/img/run-command-2.jpg)
  
  * Or action buttons

    ![vscode-actions.jpg](docs/img/vscode-actions.png)

    ![rdi-actions.jpg](docs/img/rdi-actions.png)

* Fast performance

  You can use the power of your local PC to get the build prepeared.<br/>
  This significantly improves performance.<br/>
  This is particularly important if the network and/or development partition are slow.

* See which objects are going to compile and their details:
  
  * joblog
  * spool file
  * error output
  
  ![compile-overview](/docs/img/compile-overview.png)


**If you also want to use git with that you will benefit of all it advantages:**

* Work with branches
* Version control

  ![git-commit](docs/img/git-commit.jpg)

* Integration in other tools like Atlassian JIRA
* Compare between different versions

  ![git-compare](docs/img/git-compare.jpg)

* Extended source list(s)
  * You can use a source list containing all sources and the related text description from the source files.
  * Feel free to make your own (multiple) source lists for your projects.  
  To get a list of all your needed sources in each list.
  * Extend the list with further information like
    * Category
    * Link to wiki or ticket
    * Department
    * etc.
  * This source list can be automatically generated (e.g. via SQL)

  ![source-list](docs/img/source-list.png)