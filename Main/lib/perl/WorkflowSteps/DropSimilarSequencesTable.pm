package OrthoMCLWorkflow::Main::WorkflowSteps::DropSimilarSequencesTable;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $suffix = $self->getParamValue('suffix');

    my $undoFlag = $undo? "-undo" : "";
    $self->runCmd($test, "dropSimSeqTable '$suffix' $undoFlag");
}
