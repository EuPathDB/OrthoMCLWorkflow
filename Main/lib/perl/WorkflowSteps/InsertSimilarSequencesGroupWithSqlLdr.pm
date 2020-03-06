package OrthoMCLWorkflow::Main::WorkflowSteps::InsertSimilarSequencesGroupWithSqlLdr;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $simSeqTableSuffix = $self->getParamValue('simSeqTableSuffix');
    my $simSeqGroupTableSuffix = $self->getParamValue('simSeqGroupTableSuffix');
    my $dir = $self->getParamValue('directory');
    my $workflowDataDir = $self->getWorkflowDataDir();
    $dir = $workflowDataDir."/".$dir;

    my $undoFlag = $undo? "undo" : "";
    $self->runCmd($test, "orthomclInsertSimilarSequencesGroupWithSqlLdr $dir $simSeqTableSuffix $simSeqGroupTableSuffix $undoFlag");
}
