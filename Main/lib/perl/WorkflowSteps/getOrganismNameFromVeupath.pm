package OrthoMCLWorkflow::Main::WorkflowSteps::getOrganismNameFromVeupath;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $dataDir = $self->getParamValue('dataDir');
  my $workflowDataDir = $self->getWorkflowDataDir();
  $dataDir = "$workflowDataDir/$dataDir";

  my $cmd = "orthoGetOrganismNameFromVeupath.pl --dataDir $dataDir";

  if ($undo) {
    $self->runCmd(0, "rm $dataDir/*");
  } else {
    $self->runCmd($test,$cmd);
  }
}

1;

