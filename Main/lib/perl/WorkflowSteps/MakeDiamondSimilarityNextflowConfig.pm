package OrthoMCLWorkflow::Main::WorkflowSteps::MakeDiamondSimilarityNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $seqFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("seqFile"));
  my $analysisDir = $self->getParamValue("analysisDir");
  my $clusterResultDir = join("/", $clusterWorkflowDataDir, $self->getParamValue("clusterResultDir"));
  my $blastProgram = $self->getParamValue("blastProgram");
  my $dataFile = $self->getParamValue("dataFile");
  my $logFile = $self->getParamValue("logFile");
  my $printSimSeqs = $self->getParamValue("printSimSeqs");
  my $configPath = join("/", $self->getWorkflowDataDir(),  $self->getParamValue("analysisDir"), $self->getParamValue("configFileName"));
  my $preConfiguredDatabase = $self->getParamValue("preConfiguredDatabase");
  my $database = join("/", $clusterWorkflowDataDir, $self->getParamValue("database"));
  my $pValCutoff = $self->getParamValue("pValCutoff");
  my $lengthCutoff = $self->getParamValue("lengthCutoff");
  my $percentCutoff = $self->getParamValue("percentCutoff");
  my $outputType = $self->getParamValue("outputType");
  my $adjustMatchLength = $self->getParamValue("adjustMatchLength");
  my $fastaSubsetSize = $self->getParamValue("fastaSubsetSize");
  my $blastArgs = $self->getParamValue("blastArgs");
  my $databaseFasta = join("/", $clusterWorkflowDataDir, $self->getParamValue("databaseFasta"));

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
  seqFile = \"$seqFile\"
  dataFile = \"$dataFile\"
  logFile = \"$logFile\"
  outputDir = \"$clusterResultDir\"
  blastArgs = \"$blastArgs\"
  pValCutoff = \"$pValCutoff\"
  lengthCutoff = \"$lengthCutoff\"
  percentCutoff = \"percentCutoff\"
  adjustMatchLength = $adjustMatchLength
  outputType = \"$outputType\"
  printSimSeqs = \"$printSimSeqs\"
  fastaSubsetSize = $fastaSubsetSize
  preConfiguredDatabase = $preConfiguredDatabase
  database = \"$database\"
  databaseFasta = \"$databaseFasta\"
}

process {
  executor = \'$executor\'
  queue = \'$queue\'
  container = \'rdemko2332/diamondsimilarity\'
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
