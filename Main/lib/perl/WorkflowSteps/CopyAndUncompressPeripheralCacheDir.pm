package OrthoMCLWorkflow::Main::WorkflowSteps::CopyAndUncompressPeripheralCacheDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $peripheralCacheDir = $self->getConfig("peripheralCacheDir");
  my $outputDir = join("/", $workflowDataDir, $self->getParamValue("outputDir"));

  if ($undo) {
      $self->runCmd(0, "rm -rf $outputDir/peripheralCacheDir");
  }
  elsif ($test) {
      $self->runCmd(0, "mkdir $outputDir/peripheralCacheDir");
  }
  else {
      $self->runCmd(0, "cp -r ${peripheralCacheDir} $outputDir/");
      $self->runCmd(0, "tar -xvzf ${outputDir}/peripheralCacheDir.tar.gz");
      $self->runCmd(0, "rm ${outputDir}/peripheralCacheDir.tar.gz");
  }
}

1;
