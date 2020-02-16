package OrthoMCLWorkflow::Main::WorkflowSteps::InsertSimilarSequencesGroup;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $simSeqTableSuffix = $self->getParamValue('simSeqTableSuffix');

    my $simSeqGroupTableSuffix = $self->getParamValue('simSeqGroupTableSuffix');

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $undoFlag = $undo? "undo" : "";
    $self->runCmd($test, "orthomclInsertSimilarSequencesGroup $simSeqTableSuffix $simSeqGroupTableSuffix $undoFlag");
}
