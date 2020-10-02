# OrthoMCLWorkflow

In summary, this repository supports the OrthoMCL workflow. The repository contains the workflow XML graphs and the workflow Perl modules that set up calls to plugins and scripts.

** Dependencies

   + yarn / npm / ant
   + WEBAPP_PROP_FILE file (file with one property for the webapp target directory)
      webappTargetDir=BLAH ?????

** Installation instructions.

   + bld OrthoMCLWorkflow

** Operating instructions.

   + Create config files for the appropriate OrthoMCL workflow directory such as in /eupath/data/EuPathDB/workflows/OrthoMCL/OrthoMCL6/config
   + An important config file is workflow.prop, which will define the starting workflow XML graph.
   + Use the workflow (or rf) commands to control the workflow.

** manifest

   + Main/lib/perl/WorfklowSteps :: contains Perl modules that connect steps in the worfklow xml files with Perl (or Java) scripts and plugins that carry out the work. 
   + Main/lib/xml/workflow/ :: contains static workflow xml graphs
   + Main/lib/xml/workflowTemplates/ :: contains template workflow xml graphs that are specific to a dataset class. Each will create a file with many datasets, and the file will end up in the generated directory in gus_home.
