package OrthoMCLWorkflow::Main::WorkflowSteps::ValidateNcbiTaxonId;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $abbrev = $self->getParamValue('abbrev');
    my $ncbi = $self->getParamValue('ncbiTaxonId');

    my $cmd = "orthomclValidateNcbiTaxonId $abbrev $ncbi";

    $self->runCmd($test, $cmd);
}
