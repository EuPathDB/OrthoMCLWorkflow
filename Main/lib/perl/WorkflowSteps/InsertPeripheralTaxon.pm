package OrthoMCLWorkflow::Main::WorkflowSteps::InsertPeripheralTaxon;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $abbrev = $self->getParamValue('abbrev');
    my $orthomclClade = $self->getParamValue('orthomclClade');
    my $ncbiTaxonId = $self->getParamValue('ncbiTaxonId');

    my $args = " --abbrev $abbrev --orthomclClade $orthomclClade --ncbiTaxonId $ncbiTaxonId";

    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertSinglePeripheralTaxon", $args);

}
