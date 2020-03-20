package OrthoMCLWorkflow::Main::WorkflowSteps::FixZeroExponent;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $inputFile = $self->getParamValue('inputFile');
    my $outputFile = $self->getParamValue('outputFile');
    my $deleteInputFile = $self->getParamValue('deleteInputFile');

    my $workflowDataDir = $self->getWorkflowDataDir();

    if (!$undo) {
	my $cmd = "orthomclFixZeroExponent $workflowDataDir/$inputFile $workflowDataDir/$outputFile $deleteInputFile";
	$self->runCmd($test,$cmd);
	if ($test) {
	    $self->runCmd(0, "touch $workflowDataDir/$inputFile");
	}
    }
}
