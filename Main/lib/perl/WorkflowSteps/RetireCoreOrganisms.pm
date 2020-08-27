package OrthoMCLWorkflow::Main::WorkflowSteps::RetireCoreOrganisms;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $abbrevList = $self->getParamValue('abbrevList');
  my $mainDataDir = $self->getParamValue('mainDataDir');

  if ($undo) {

  } else {

      my $args = " --mainDataDir $mainDataDir --abbrevList $abbrevList";
      $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::RetireCoreOrganisms", $args);

  }
}
