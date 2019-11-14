package OrthoMCLWorkflow::Main::WorkflowSteps::InsertGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $corePeripheralResidual = $self->getParamValue('corePeripheralResidual');

    my $groupsFile = $self->getParamValue('inputGroupsFile');

    my $orthoFileFullPath = "$workflowDataDir/$groupsFile";

    my $args = " --orthoFile $orthoFileFullPath --corePeripheralResidual $corePeripheralResidual --extDbName OrthoMCL --extDbVersion dontcare";

    $self->testInputFile('inputGroupsDir', "$orthoFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertOrthologousGroupsFromMcl", $args);

}
