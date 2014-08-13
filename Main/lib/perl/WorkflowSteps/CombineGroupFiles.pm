package OrthoMCLWorkflow::Main::WorkflowSteps::CombineGroupFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $mappedGroupsFile = $self->getParamValue('mappedGroupsFile');
  my $residualsGroupsFile = $self->getParamValue('residualsGroupsFile');
  my $outputGroupsFile = $self->getParamValue('outputGroupsFile');
  my $outputGroupsDir = $self->getParamValue('groupsDir');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm $workflowDataDir/$outputGroupsDir/$outputGroupsFile") if -e "$workflowDataDir/$outputGroupsDir/$outputGroupsFile";
    $self->runCmd(0, "rm -rf $workflowDataDir/$outputGroupsDir") if -d "$workflowDataDir/$outputGroupsDir";
  } else {
    $self->testInputFile('mappedGroupsFile', "$workflowDataDir/$mappedGroupsFile");
    $self->testInputFile('residualsGroupsFile', "$workflowDataDir/$residualsGroupsFile");
    my $cmd2 = "mkdir $workflowDataDir/$outputGroupsDir";
    my $cmd = "orthomclMergeGroupFiles $workflowDataDir/$mappedGroupsFile $workflowDataDir/$residualsGroupsFile $workflowDataDir/$outputGroupsDir/$outputGroupsFile";
    $self->runCmd($test, $cmd2);
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "mkdir $workflowDataDir/$outputGroupsDir");
      $self->runCmd(0, "touch $workflowDataDir/$outputGroupsDir/$outputGroupsFile");
    }

  }
}


