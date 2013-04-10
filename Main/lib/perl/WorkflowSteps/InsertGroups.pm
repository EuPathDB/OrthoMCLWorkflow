package ApiCommonWorkflow::Main::WorkflowSteps::InsertGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();


   my $orthoFileFullPath = "$mgr->{dataDir}/mcl/$orthoFile";

   my $signal = "loadOrthoMCLResult";
   return if $mgr->startStep("Starting Data Load $signal", $signal);

   my $args = " --orthoFile $orthoFileFullPath --extDbName '$extDbName' --extDbVersion '$extDbRlsVer' $addedArgs";

   $mgr->runPlugin($signal, 
         "OrthoMCLData::Load::Plugin::InsertOrthologousGroupsFromMcl", 
         $args,
         "Loading OrthoMCL output");

  $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertGroups", "");

}
