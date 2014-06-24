package OrthoMCLWorkflow::Main::WorkflowSteps::AddOrphansToResiduals;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $inputGroupsFile = $self->getParamValue('inputGroupsFile');
  my $inputProteinsFile = $self->getParamValue('inputProteinsFile');
  my $inputResidualsFile = $self->getParamValue('inputResidualsFile');
  my $outputResidualsFile = $self->getParamValue('outputResidualsFile');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm $workflowDataDir/$outputResidualsFile") if -e "$workflowDataDir/$outputResidualsFile";
  } else {
    $self->testInputFile('inputGroupsFile', "$workflowDataDir/$inputGroupsFile");
    $self->testInputFile('inputProteinsFile', "$workflowDataDir/$inputProteinsFile");
    $self->testInputFile('inputResidualsFile', "$workflowDataDir/$inputResidualsFile");

    my $cmd = "addOrphansToResiduals $workflowDataDir/$inputGroupsFile $workflowDataDir/$inputResidualsFile $workflowDataDir/$inputProteinsFile  $workflowDataDir/$outputResidualsFile";
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "touch $workflowDataDir/$outputResidualsFile");
    }

  }
}


