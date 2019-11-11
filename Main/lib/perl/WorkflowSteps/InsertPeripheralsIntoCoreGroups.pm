package OrthoMCLWorkflow::Main::WorkflowSteps::InsertPeripheralsIntoCoreGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $groupsFile = $self->getParamValue('inputGroupsFile');

    my $orthoFileFullPath = "$workflowDataDir/$groupsFile";

    my $args = " --orthoFile $orthoFileFullPath --extDbName OrthoMCL --extDbVersion dontcare";

    $self->testInputFile('inputGroupsFile', "$orthoFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertMappedPeripheralsIntoCoreGroups", $args);

}
