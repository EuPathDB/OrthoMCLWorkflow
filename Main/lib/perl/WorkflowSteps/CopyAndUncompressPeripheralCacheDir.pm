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
      $self->runCmd($test, "mkdir $outputDir/peripheralCacheDir");
  }
  else {
      $self->runCmd($test, "cp -r ${peripheralCacheDir} $outputDir/peripheralCacheDir.tar.gz");
      die "$outputDir/peripheralCacheDir.tar.gz does not exist" unless(-e "$outputDir/peripheralCacheDir.tar.gz");
      $self->runCmd($test, "tar -xvzf ${outputDir}/peripheralCacheDir.tar.gz -C $outputDir");
      die "$outputDir/peripheralCacheDir does not exist" unless(-d "$outputDir/peripheralCacheDir");
      $self->runCmd($test, "rm ${outputDir}/peripheralCacheDir.tar.gz");
  }
}

1;
