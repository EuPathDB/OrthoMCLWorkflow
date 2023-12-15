package OrthoMCLWorkflow::Main::WorkflowSteps::InsertGroupStatistics;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $corePeripheralResidual = $self->getParamValue('corePeripheralResidual');

    my $groupStatsFile = $self->getParamValue('groupStatsFile');

    my $groupStatsFileFullPath = "$workflowDataDir/$groupStatsFile";

    my $args = " --groupStatsFile $groupStatsFileFullPath --corePeripheralResidual $corePeripheralResidual";

    $self->testInputFile('inputGroupsDir', "$groupStatsFileFullPath");
    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertGroupStatistics", $args);

}
