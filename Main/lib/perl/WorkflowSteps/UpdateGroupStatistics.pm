package OrthoMCLWorkflow::Main::WorkflowSteps::UpdateGroupStatistics;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();

  $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::UpdateOrthologGroups", "");

}
