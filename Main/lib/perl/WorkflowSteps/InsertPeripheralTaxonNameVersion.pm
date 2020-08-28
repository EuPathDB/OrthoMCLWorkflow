package OrthoMCLWorkflow::Main::WorkflowSteps::InsertPeripheralTaxonNameVersion;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $abbrev = $self->getParamValue('abbrev');
    my $orthomclClade = $self->getParamValue('orthomclClade');
    my $ncbiTaxonId = $self->getParamValue('ncbiTaxonId');
    my $version = $self->getParamValue('version');
    my $organismName = $self->getParamValue('organismName');

    my $args = " --abbrev $abbrev --orthomclClade $orthomclClade --ncbiTaxonId $ncbiTaxonId --version $version --organismName $organismName";

    $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::InsertSinglePeripheralTaxonNameVersion", $args);

}
