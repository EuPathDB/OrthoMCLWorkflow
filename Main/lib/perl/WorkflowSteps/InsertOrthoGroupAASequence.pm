package OrthoMCLWorkflow::Main::WorkflowSteps::InsertOrthoGroupAASequence;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $groupsFile = $self->getParamValue('groupsFile');

    my $isResidual = $self->getParamValue('isResidual');

    my $orthoVersion = $self->getConfig('buildVersion');

    my $orthoFileFullPath = "$workflowDataDir/$groupsFile";

    my $args = " --orthoFile $orthoFileFullPath --isResidual $isResidual --orthoVersion $orthoVersion";

    $self->testInputFile('inputGroupsDir', "$orthoFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertOrthoGroupAASequence", $args);

}
