package OrthoMCLWorkflow::Main::WorkflowSteps::MapPeripheralsToGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $peripheralsFastaFile = $self->getParamValue('peripheralsFastaFile');
  my $referenceGroupsFile = $self->getParamValue('referenceGroupsFile');
  my $similarSequencesFile = $self->getParamValue('similarSequencesFile');
  my $outputGroupsFile = $self->getParamValue('outputGroupsFile');
  my $outputResidualsFile = $self->getParamValue('outputResidualsFile');
  my $threshold = $self->getParamValue('threshold');
  my $minPercentMatch = $self->getParamValue('minPercentMatch');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm $workflowDataDir/$outputGroupsFile") if -e "$workflowDataDir/$outputGroupsFile";
    $self->runCmd(0, "rm $workflowDataDir/$outputResidualsFile") if -e "$workflowDataDir/$outputResidualsFile";
  } else {
    $self->testInputFile('referenceGroupsFile', "$workflowDataDir/$referenceGroupsFile");
    $self->testInputFile('peripheralsFastaFile', "$workflowDataDir/$peripheralsFastaFile");
    $self->testInputFile('similarSequencesFile', "$workflowDataDir/$similarSequencesFile");

    my $cmd = "mapPeripheralsToGroups $peripheralsFastaFile $referenceGroupsFile $similarSequencesFile $outputGroupsFile $outputResidualsFile $threshold $minPercentMatch";
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "echo test > $workflowDataDir/$outputGroupsFile");
      $self->runCmd(0, "echo test > $workflowDataDir/$outputResidualsFile");
    }

  }
}


