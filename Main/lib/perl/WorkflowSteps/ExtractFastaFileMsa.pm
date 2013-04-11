package ApiCommonWorkflow::Main::WorkflowSteps::ExtractFilesForMsa;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $outputDir = $self->getParamValue('outputDir');
    my $tarSize = $self->getParamValue('filesPerTarball');
    
    $self->testInputFile('outputDir', "$workflowDataDir/$outputDir");

    if ($undo) {
	$self->runCmd($test, "rm -r $workflowDataDir/$outputDir");	
    } else{
	$self->runCmd($test, "extractGroupFastaFiles --outputDir $workflowDataDir/$outputDir --tarBall $tarSize");
    }
}
