package OrthoMCLWorkflow::Main::WorkflowSteps::MakeGroupSelfBlastNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $groupSelfCache = $self->getConfig('groupSelfCache');
  my $outdated = $self->getConfig('outdated');
  my $coreProteome = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreProteome"));
  my $peripheralProteome = join("/", $clusterWorkflowDataDir, $self->getParamValue("peripheralProteome"));
  my $coreGroupsFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("coreGroupsFile"));
  my $peripheralGroupsFile = join("/", $clusterWorkflowDataDir, $self->getParamValue("peripheralGroupsFile"));
  my $analysisDir = $self->getParamValue("analysisDir");
  my $pValCutoff  = $self->getParamValue("pValCutoff");
  my $lengthCutoff  = $self->getParamValue("lengthCutoff");
  my $percentCutoff  = $self->getParamValue("percentCutoff");
  my $adjustMatchLength   = $self->getParamValue("adjustMatchLength");
  my $blastArgs = $self->getParamValue("blastArgs");

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
  coreProteome = \"$coreProteome\"
  peripheralProteome = \"$peripheralProteome\"
  coreGroupsFile = \"$coreGroupsFile\"
  peripheralGroupsFile = \"$peripheralGroupsFile\"
  updateList = \"$outdated\"
  outputDir = \"$clusterResultDir\"
  pValCutoff  = $pValCutoff
  lengthCutoff  = $lengthCutoff
  percentCutoff  = $percentCutoff
  adjustMatchLength   = $adjustMatchLength
  blastArgs = \"$blastArgs\"
}

process {
  executor = \'$executor\'
  queue = \'$queue\'
}

singularity {
  enabled = true
  autoMounts = true
  runOptions = \"--bind $groupSelfCache:/cache\"
}
";
  close(F);
 }
}

1;

