package OrthoMCLWorkflow::Main::WorkflowSteps::PredictEcNumbers;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $version = $self->getParamValue('version');
  $version =~ s/_//g;
  my $ouputDir = $self->getParamValue('outputDir');
  my $organismDir = $workflowDataDir."/".$organismDir;

  if ($undo) {
  } else {
    my $cmd = "orthomclEcPrediction $outputDir $organismDir $version";
    $self->runCmd($test, $cmd);

    if ($test) {
      $self->runCmd(0, "touch $organismDir);
    }
  }
}


