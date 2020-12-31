package OrthoMCLWorkflow::Main::WorkflowSteps::GetProteomeFromManualDelivery;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $manualDeliveryFile = $self->getParamValue('manualDeliveryFile');
  my $outputDir = $self->getParamValue('outputDir');
  my $outputFile = $self->getParamValue('outputFile');

  my $workflowDataDir = $self->getWorkflowDataDir();
  $outputDir = "$workflowDataDir/$outputDir";
  $outputFile = "$outputDir/$outputFile";
  my $zipped = $outputFile.".gz";

  if ($undo) {
    $self->runCmd(0, "if [-e $zipped]; then rm $zipped; fi");
    $self->runCmd(0, "if [-e $outputFile]; then rm $outputFile; fi");
  } else {
    $self->runCmd($test,"cp $manualDeliveryFile $outputDir");
    $self->runCmd($test,"if [-e $zipped]; then gunzip -d $zipped; fi");
  }
}

1;

