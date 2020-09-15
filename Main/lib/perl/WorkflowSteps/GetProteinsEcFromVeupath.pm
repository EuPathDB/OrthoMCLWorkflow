package OrthoMCLWorkflow::Main::WorkflowSteps::GetProteinsEcFromVeupath;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $orthomclAbbrev = $self->getParamValue('orthomclAbbrev');
  my $outputDir = $self->getParamValue('outputDir');
  my $projectName = $self->getParamValue('projectName');
  my $ecFileName = $self->getParamValue('ecFileName');
  my $proteomeFileName = $self->getParamValue('proteomeFileName');
  my $downloadFileName = $self->getParamValue('downloadFileName');
  my $logFileName = $self->getParamValue('logFileName');
  my $organismName = $self->getParamValue('organismName');

  my $workflowDataDir = $self->getWorkflowDataDir();
  $outputDir = "$workflowDataDir/$outputDir";
  $proteomeFileName = "$outputDir/$proteomeFileName";
  $ecFileName = "$outputDir/$ecFileName";
  $downloadFileName = "$outputDir/$downloadFileName";
  $logFileName = "$outputDir/$logFileName";

  my $cmd = "orthoGetProteinsEcFromVeupath.pl --orthomclAbbrev $orthomclAbbrev --proteomeFileName $proteomeFileName --ecFileName $ecFileName --downloadFileName $downloadFileName --projectName $projectName --organismName $organismName";

  if ($undo) {
    $self->runCmd(0, "rm $proteomeFileName");
    $self->runCmd(0, "rm $ecFileName");
    $self->runCmd(0, "rm $downloadFileName");
    $self->runCmd(0, "rm $logFileName");
  } else {
    $self->runCmd($test,$cmd);
  }
}

1;

