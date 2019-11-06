package OrthoMCLWorkflow::Main::WorkflowSteps::CopyOrthoGroupTables;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $orthoGroupTable = $self->getParamValue('orthoGroupTable');
    my $orthoGroupAaTable = $self->getParamValue('orthoGroupAaTable');

    my $undoFlag = $undo? "-undo" : "";
    $self->runCmd($test, "copyOrthologGroupTables '$orthoGroupTable' '$orthoGroupAaTable' $undoFlag");
}
