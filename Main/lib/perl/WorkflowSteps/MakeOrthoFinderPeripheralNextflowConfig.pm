package OrthoMCLWorkflow::Main::WorkflowSteps::MakeOrthoFinderPeripheralNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $analysisDir = $self->getParamValue("analysisDir");
  my $peripheralProteomes = join("/", $clusterWorkflowDataDir, $self->getParamValue("peripheralProteomes"));
  my $coreProteomes = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreProteome"));
  my $coreBestRepsFasta = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreBestRepsFasta"));
  my $coreBestReps = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreBestReps"));
  my $coreGroupsFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreGroupsFile"));
  my $coreSimilarityToBestReps = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreSimilarityToBestReps"));
  my $coreBestRepsSelfBlast = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreBestRepsSelfBlast"));
  my $buildVersion = $self->getConfig("buildVersion");
  my $peripheralCacheDir = join("/", $clusterWorkflowDataDir, $self->getParamValue("peripheralCacheDir"));
  my $outdatedOrganisms = join("/", $clusterWorkflowDataDir, $self->getParamValue("outdated"));

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
    outputDir = \"$clusterResultDir\"
    coreProteomes = \"$coreProteomes\"
    coreBestReps = \"$coreBestReps\"
    coreBestRepsFasta = \"$coreBestRepsFasta\"
    peripheralProteomes = \"$peripheralProteomes\"
    coreGroupsFile = \"$coreGroupsFile\"
    outdatedOrganisms = \"$outdatedOrganisms\"
    peripheralDiamondCache = \"$peripheralCacheDir\"
    coreSimilarityToBestReps = \"$coreSimilarityToBestReps\"
    coreBestRepsSelfBlast = \"$coreBestRepsSelfBlast\"
    blastArgs = \"\"
    buildVersion = $buildVersion
    bestRepDiamondOutputFields = \"qseqid sseqid evalue\"
    orthoFinderDiamondOutputFields = \"qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore\"

}

process {
  executor = \'$executor\'
  queue = \'$queue\'
  withName: \'peripheralDiamond\' {
    errorStrategy = { task.exitStatus in 130..140 ? \'retry\' : \'finish\' }
    clusterOptions = {
      (task.attempt > 1 && task.exitStatus in 130..140)
        ? \'-M 20000 -R \"rusage [mem=20000] span[hosts=1]\"\'
        : \'-M 25000 -R \"rusage [mem=25000] span[hosts=1]\"\'
    }
  }
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

