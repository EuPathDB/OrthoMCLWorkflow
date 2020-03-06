package OrthoMCLWorkflow::Main::WorkflowSteps::InsertOrthomclResource;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $proteomesFromBuild = $self->getParamValue('proteomesFromBuild');

    my $args = "--proteomesFromBuild $proteomesFromBuild";

    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertOrthomclResource", $args);

}
