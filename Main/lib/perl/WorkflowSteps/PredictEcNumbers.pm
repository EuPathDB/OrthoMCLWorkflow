package OrthoMCLWorkflow::Main::WorkflowSteps::PredictEcNumbers;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $ouputDir = $self->getParamValue('outputDir');
  my $organismDir = $workflowDataDir."/".$organismDir;

  if ($undo) {
      my $files = $outputDir."/*";
      $files =~ s/PROJECT/*/;
      my $cmd = "rm -rf $files";
      $self->runCmd($test, $cmd);      
  } else {
    my $cmd = "orthomclEcPrediction $outputDir $organismDir";
    $self->runCmd($test, $cmd);
  }
}


