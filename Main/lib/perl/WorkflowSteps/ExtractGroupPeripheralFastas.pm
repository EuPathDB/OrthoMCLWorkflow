package OrthoMCLWorkflow::Main::WorkflowSteps::ExtractGroupPeripheralFastas;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $outputDir = $self->getParamValue('outputDir');
    my $outputTar = $self->getParamValue('outputTar');

    if ($undo) {
	$self->runCmd($test, "rm -r $workflowDataDir/$outputDir");
	$self->runCmd($test, "rm -r $workflowDataDir/$outputTar");
    } else{
      if ($test) {
	$self->runCmd(0, "mkdir $workflowDataDir/$outputDir");
	$self->runCmd(0, "touch $workflowDataDir/$outputTar");
      } else {
	$self->runCmd($test, "extractGroupFastaFiles --outputDir $workflowDataDir/$outputDir --peripheralsOnly");
	$self->runCmd($test, "tar -zcf $workflowDataDir/${outputDir}.tar.gz $workflowDataDir/$outputDir");
      }
    }
}
