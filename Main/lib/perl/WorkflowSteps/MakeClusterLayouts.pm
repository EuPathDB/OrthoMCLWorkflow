package OrthoMCLWorkflow::Main::WorkflowSteps::MakeClusterLayouts;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $maxNodes = $self->getParamValue('maxGroupSize');

  if ($undo) {
    $self->runCmd($test, "orthomclClusterLayout -undo");
  } else {
    my $cmd = "orthomclClusterLayout -max $maxNodes";
    $self->runCmd($test, $cmd);
  }
}


