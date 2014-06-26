package OrthoMCLWorkflow::Main::WorkflowSteps::InsertGroups;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $inputFile = $self->getParamValue('inputGroupsFile');

    my $orthoFileFullPath = "$workflowDataDir/$inputFile";

    my $args = " --orthoFile $orthoFileFullPath --extDbName OrthoMCL --extDbVersion dontcare";

    $self->testInputFile('inputGroupsDir', "$orthoFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertOrthologousGroupsFromMcl", $args);

}
