package OrthoMCLWorkflow::Main::WorkflowSteps::FixZeroExponent;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $simSeqTableSuffix = $self->getParamValue('simSeqTableSuffix');

    my $args = " --simSeqTableSuffix $simSeqTableSuffix";

    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::orthomclFixZeroExponent", $args);

}
