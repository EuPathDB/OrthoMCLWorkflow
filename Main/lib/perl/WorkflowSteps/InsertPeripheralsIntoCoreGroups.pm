package OrthoMCLWorkflow::Main::WorkflowSteps::InsertPeripheralsIntoCoreGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $corePeripheralResidual = $self->getParamValue('corePeripheralResidual');

    my $peripheralGroupFile = $self->getParamValue('peripheralGroupsFile');

    my $orthoFileFullPath = "$workflowDataDir/$peripheralGroupFile";

    my $args = " --peripheralGroupsFile $orthoFileFullPath --corePeripheralResidual $corePeripheralResidual";

    $self->testInputFile('inputGroupsDir', "$orthoFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertPeripheralsToGroups", $args);

}
