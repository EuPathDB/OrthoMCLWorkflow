package OrthoMCLWorkflow::Main::WorkflowSteps::MakeGenomicSitesFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $orthomclVersion = $self->getParamValue('orthomclVersion');
  my $peripheralDir = $self->getParamValue('peripheralDir');
  my $peripheralMapFileName = $self->getParamValue('peripheralMapFileName');
  my $coreMapFile = $self->getParamValue('coreMapFile');
  my $residualMapFile = $self->getParamValue('residualMapFile');
  my $cladeFile = $self->getParamValue('cladeFile');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm -rf $workflowDataDir/$orthomclVersion") if -e "$workflowDataDir/$orthomclVersion";
  } else {
    my $cmd = "orthomclMakeGenomicSitesFiles $workflowDataDir/$orthomclVersion $workflowDataDir/$peripheralDir $peripheralMapFileName $workflowDataDir/$coreMapFile $workflowDataDir/$residualMapFile $workflowDataDir/$cladeFile";
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "touch $workflowDataDir/$peripheralDir");
      $self->runCmd(0, "touch $workflowDataDir/$coreMapFile");
      $self->runCmd(0, "touch $workflowDataDir/$residualMapFile");
      $self->runCmd(0, "touch $workflowDataDir/$cladeFile");
    }
  }
}


