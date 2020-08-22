package OrthoMCLWorkflow::Main::WorkflowSteps::MakeAliasFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $firstFile = $self->getParamValue('firstFile');
  my $secondFile = $self->getParamValue('secondFile');
  my $outputFile = $self->getParamValue('outputFile');
  my $abbrev = $self->getParamValue('abbrev');

  if ($undo) {
    $self->runCmd($test, "rm $workflowDataDir/$outputFile");
  } else {
      $self->testInputFile('firstFile', "$workflowDataDir/$firstFile");
      $self->testInputFile('secondFile', "$workflowDataDir/$secondFile");
      my $cmd = "orthomclMakeUniprotAliasesFile $abbrev $workflowDataDir/$firstFile $workflowDataDir/$outputFile $workflowDataDir/$outputFile ";
    $self->runCmd($test, $cmd);
  }
}
