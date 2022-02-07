package OrthoMCLWorkflow::Main::WorkflowSteps::MapPeripheralsToGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $outputGroupsFile = $self->getParamValue('outputGroupsFile');
  my $inputFastaFile = $self->getParamValue('inputFastaFile');
  my $residualFastaFile = $self->getParamValue('residualFastaFile');
  my $inputSimilarSequencesTable = $self->getParamValue('inputSimilarSequencesTable');
  my $abbrev = $self->getParamValue('abbrev');
  my $pvalueExponentCutoff = $self->getParamValue('pvalueExponentCutoff');
  my $percentMatch = $self->getParamValue('percentMatch');
  my $coreGroupsFile = $self->getParamValue('coreGroupsFile');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm $workflowDataDir/$outputGroupsFile") if -e "$workflowDataDir/$outputGroupsFile";
    $self->runCmd(0, "rm $workflowDataDir/$residualFastaFile") if -e "$workflowDataDir/$residualFastaFile";
  } else {
    my $cmd = "peripheralsToGroupsAndResiduals $workflowDataDir/$outputGroupsFile $workflowDataDir/$inputFastaFile $workflowDataDir/$residualFastaFile $inputSimilarSequencesTable $abbrev $pvalueExponentCutoff $percentMatch $workflowDataDir/$coreGroupsFile";
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "touch $workflowDataDir/$outputGroupsFile");
      $self->runCmd(0, "touch $workflowDataDir/$residualFastaFile");
    }

  }
}


