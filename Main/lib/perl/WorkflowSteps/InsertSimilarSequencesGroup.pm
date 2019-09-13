package OrthoMCLWorkflow::Main::WorkflowSteps::InsertSimilarSequencesGroup;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $undoFlag = $undo? "-undo" : "";
    $self->runCmd($test, "orthomclInsertSimilarSequencesGroup $undoFlag");
}
