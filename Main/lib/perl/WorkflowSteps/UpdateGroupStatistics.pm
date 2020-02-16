package OrthoMCLWorkflow::Main::WorkflowSteps::UpdateGroupStatistics;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $simSeqTableSuffix = $self->getParamValue('simSeqTableSuffix');
  my $orthologTableSuffix = $self->getParamValue('orthologTableSuffix');
  my $groupTypesCPR = $self->getParamValue('groupTypesCPR');
  my $overwriteExisting = $self->getParamValue('overwriteExisting');

  my $args = " --simSeqTableSuffix $simSeqTableSuffix --orthologTableSuffix $orthologTableSuffix --groupTypesCPR $groupTypesCPR --overwriteExisting $overwriteExisting";

  $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::UpdateOrthologGroup", $args);

}
