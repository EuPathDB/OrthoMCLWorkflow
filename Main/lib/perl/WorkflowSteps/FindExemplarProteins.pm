package OrthoMCLWorkflow::Main::WorkflowSteps::FindExemplarProteins;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $fastaFile = $self->getParamValue('fastaFile');
  my $outputFile = $self->getParamValue('outputFile');
  my $geneIdRegex = $self->getParamValue('geneIdRegex');
  my $proteinIdRegex = $self->getParamValue('proteinIdRegex');
  my $maxStopCodonPercent = $self->getParamValue('maxStopCodonPercent');
  my $preferredSource = $self->getParamValue('preferredSource');

  if ($undo) {
    $self->runCmd($test, "rm $workflowDataDir/$outputFile");
  } else {
      $self->testInputFile('fastaFile', "$workflowDataDir/$fastaFile");
      my $cmd = "findExemplarProteinsFromFasta --fastaFile $workflowDataDir/$fastaFile --outputFile $workflowDataDir/$outputFile --geneIdRegex '$geneIdRegex' --proteinIdRegex '$proteinIdRegex' --maxStopCodonPercent $maxStopCodonPercent --preferredSource $preferredSource ";
    $self->runCmd($test, $cmd);
  }
}
