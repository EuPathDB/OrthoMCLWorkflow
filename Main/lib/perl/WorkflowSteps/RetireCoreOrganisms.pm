package OrthoMCLWorkflow::Main::WorkflowSteps::RetireCoreOrganisms;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $abbrevList = $self->getParamValue('abbrevList');
  my $mainDataDir = $self->getParamValue('mainDataDir');
  my $skipIfAlreadyDone = $self->getParamValue('skipIfAlreadyDone');
  my $cluster = $self->getSharedConfig('clusterServer');
  my $clusterUser = $self->getSharedConfig("$cluster.clusterLogin");
  my $clusterDir = $self->getSharedConfig("$cluster.clusterBaseDir");
  if ($mainDataDir =~ /(workflows.+data)/) {
      $clusterDir .= "/$1/";
  } else {
      die "Cannot obtain workflow data directory from '$mainDataDir'\n";
  }

  if ($undo) {
  } else {

      my $args = " --mainDataDir $mainDataDir --abbrevList $abbrevList --skip $skipIfAlreadyDone --cluster $cluster --clusterUser $clusterUser --clusterDir $clusterDir";
      $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::RetireCoreOrganisms", $args);

  }
}
