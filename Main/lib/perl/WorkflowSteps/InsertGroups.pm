package OrthoMCLWorkflow::Main::WorkflowSteps::InsertGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $isResidual = $self->getParamValue('isResidual');

    my $orthoVersion = $self->getConfig('buildVersion');

    my $groupsFile = $self->getParamValue('groupsFile');

    my $orthoFileFullPath = "$workflowDataDir/$groupsFile";

    my $args = " --orthoFile $orthoFileFullPath --isResidual $isResidual --orthoVersion $orthoVersion --extDbName OrthoMCL --extDbVersion dontcare";

    $self->testInputFile('inputGroupsDir', "$orthoFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertOrthoGroups", $args);

}
