package OrthoMCLWorkflow::Main::WorkflowSteps::CombineResidualFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $residualFastaFilesDir = $self->getParamValue('residualFastaFilesDir');
  my $combinedResidualsFile = $self->getParamValue('combinedResidualsFile');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm $workflowDataDir/$combinedResidualsFile") if -e "$workflowDataDir/$combinedResidualsFile";
  } else {
    my $cmd = "orthomclCombineResidualFiles $workflowDataDir/$residualFastaFilesDir $workflowDataDir/$combinedResidualsFile";
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "touch $workflowDataDir/$residualFastaFilesDir");
    }

  }
}


