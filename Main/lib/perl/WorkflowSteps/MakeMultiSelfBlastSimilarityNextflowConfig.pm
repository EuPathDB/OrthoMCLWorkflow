package OrthoMCLWorkflow::Main::WorkflowSteps::MakeMultiSelfBlastSimilarityNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $tarFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("tarFile"));
  my $analysisDir = $self->getParamValue("analysisDir");
  my $clusterResultDir = join("/", $clusterWorkflowDataDir, $self->getParamValue("clusterResultDir"));
  my $blastProgram = $self->getParamValue("blastProgram");
  my $dataFile = $self->getParamValue("dataFile");
  my $logFile = $self->getParamValue("logFile");
  my $printSimSeqs = $self->getParamValue("printSimSeqs");
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
  blastProgram = \"$blastProgram\"
  tarFile = \"$tarFile\"
  dataFile = \"$dataFile\"
  logFile = \"$logFile\"
  outputDir = \"$clusterResultsDir\"
  blastArgs = \"\"
  pValCutoff = 1e-5
  lengthCutoff = 10
  percentCutoff = 20
  adjustMatchLength = false 
  outputType = \"both\"
  printSimSeqs = \"$printSimSeqs\"
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

