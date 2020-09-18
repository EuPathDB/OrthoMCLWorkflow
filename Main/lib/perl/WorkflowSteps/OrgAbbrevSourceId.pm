package OrthoMCLWorkflow::Main::WorkflowSteps::OrgAbbrevSourceId;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workDir = $self->getWorkflowDataDir();

  my $regex = $self->getParamValue('geneRegex');
  my $in = $self->getParamValue('inputFile');
  my $out = $self->getParamValue('outputFile');
  my $abbrev = $self->getParamValue('abbrev');

  if ($undo) {
    $self->runCmd($test, "rm $workDir/$outputFile");
  } else {
      $self->testInputFile('inputFile', "$workDir/$in");
      my $cmd = "orgAbbrevSourceId --inputFile $workDir/$in --abbrev $abbrev --geneRegex '$regex' --outputFile $workDir/$out";
      $self->runCmd($test, $cmd);
  }
}
