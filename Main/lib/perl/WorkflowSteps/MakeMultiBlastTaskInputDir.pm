package ApiCommonWorkflow::Main::WorkflowSteps::MakeMultiBlastTaskInputDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::MakeBlastTaskInputDir);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::MakeBlastTaskInputDir;

sub testInput {
    my ($self, $worflowDataDir) = @_;

    my $fastaDirTarFile = $self->getParamValue("fastaDirTarFile");
    my $referenceDatabaseFasta = $self->getParamValue("referenceDatabaseFasta");

    $self->testInputFile('fastaDirTarFile', "$workflowDataDir/$fastaDirTarFile");
    $self->testInputFile('referenceDatabaseFasta', "$workflowDataDir/$referenceDatabaseFasta");
}

sub getPathParamsString {
    my ($self, $clusterWorkflowDataDir) = @_;

    my $fastaDirTarFile = $self->getParamValue("fastaDirTarFile");

    return "dbFilePath=$clusterWorkflowDataDir/$fastaDirTarFile";
}

sub addExtraBlastArgs {
    my ($self, $worflowDataDir, $blastArgs) = @_;

    my $referenceDatabaseFasta = $self->getParamValue("referenceDatabaseFasta");
    open(F, "$worflowDataDir/$referenceDatabaseFasta") || die "can't open referenceDatabaseFasta '$worflowDataDir/$referenceDatabaseFasta'";

    my $count;
    while(<F>) {
	$count++ if /^>/;
    }
    return "$blastArgs -z $count";
}

1;
