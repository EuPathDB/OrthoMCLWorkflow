package OrthoMCLWorkflow::Main::WorkflowSteps::GetOldReleasesGroupFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $inputDir = $self->getParamValue('inputDir');  # download site dir including all previous releases (but not the one we are building)
  my $outputDir = $self->getParamValue('outputDir'); # where to put the old group files (all with a similar name format)

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $fromDir = "$workflowDataDir/$inputDir";
  my $targetDir = "$workflowDataDir/$outputDir";

  $self->testInputFile('inputDir', $fromDir);

  if ($undo) {
    $self->runCmd(0,"rm -r $targetDir");
  } else {
    if ($test) {
      $self->runCmd($test, "mkdir $targetDir");
    } else {
      $self->runCmd($test, "getOrthomclOldRlsGroupFiles $fromDir $targetDir");
    }
  }
}
