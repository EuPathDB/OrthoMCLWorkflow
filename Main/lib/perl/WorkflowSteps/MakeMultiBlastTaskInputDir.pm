package OrthoMCLWorkflow::Main::WorkflowSteps::MakeMultiBlastTaskInputDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::MakeBlastTaskInputDir);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::MakeBlastTaskInputDir;

sub testInput {
    my ($self, $workflowDataDir) = @_;

    my $fastaDirTarFile = $self->getParamValue("fastaDirTarFile");
    my $coreDatabaseFasta = $self->getParamValue("coreDatabaseFasta");

    $self->testInputFile('fastaDirTarFile', "$workflowDataDir/$fastaDirTarFile");
    $self->testInputFile('coreDatabaseFasta', "$workflowDataDir/$coreDatabaseFasta");
}

sub getPathParamsString {
    my ($self, $clusterWorkflowDataDir) = @_;

    my $fastaDirTarFile = $self->getParamValue("fastaDirTarFile");

    return "fastasTarPath=$clusterWorkflowDataDir/$fastaDirTarFile";
}

sub getTask {
  return "DJob::DistribJobTasks::MultiBlastSimilarityTask";
}
sub addExtraBlastArgs {
    my ($self, $worflowDataDir, $blastArgs) = @_;

    my $coreDatabaseFasta = $self->getParamValue("coreDatabaseFasta");
    open(F, "$worflowDataDir/$coreDatabaseFasta") || die "can't open coreDatabaseFasta '$worflowDataDir/$coreDatabaseFasta'";

    my $count;
    while(<F>) {
	$count++ if /^>/;
    }
    return "$blastArgs -z $count";
}

1;
