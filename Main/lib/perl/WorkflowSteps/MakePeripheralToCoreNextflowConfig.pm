package OrthoMCLWorkflow::Main::WorkflowSteps::MakePeripheralToCoreNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $seqFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("seqFile"));
  my $analysisDir = $self->getParamValue("analysisDir");
  my $databaseFasta = join("/", $clusterWorkflowDataDir, $self->getParamValue("databaseFasta"));
  my $diamondArgs   = $self->getParamValue("diamondArgs");

  my $clusterResultDir = join("/", $clusterWorkflowDataDir, $self->getParamValue("clusterResultDir"));
  my $configPath = join("/", $self->getWorkflowDataDir(),  $self->getParamValue("analysisDir"), $self->getParamValue("configFileName"));

  my $executor = $self->getClusterExecutor();
  my $queue = $self->getClusterQueue();

  if ($undo) {
    $self->runCmd(0,"rm -rf $configPath");
  } else {
    open(F, ">", $configPath) or die "$! :Can't open config file '$configPath' for writing";

    print F
"
params {
  fastaSubsetSize = 10000
  seqFile = \"$seqFile\"
  outputDir = \"$clusterResultDir\"
  databaseFasta = \"$databaseFasta\"
  diamondArgs = \"$diamondArgs\"
}

process {
  executor = \'$executor\'
  queue = \'$queue\'
}

singularity {
  enabled = true
  autoMounts = true
}
";
  close(F);
 }
}

1;

