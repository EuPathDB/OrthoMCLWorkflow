package OrthoMCLWorkflow::Main::WorkflowSteps::MakeMuscleTaskInputDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::MakeTaskInputDir);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::MakeTaskInputDir;

sub testMode {
    my ($self, $workflowDataDir) = @_;

    my $fastaFilesDir = $self->getParamValue('fastaFilesDir');
    $self->testInputFile('fastaFilesDir', "$workflowDataDir/$fastaFilesDir");
}

sub getTaskPropFileContents {
    my ($self, $clusterWorkflowDataDir) = @_;
    # get parameters
    my $fastaFilesDir = $self->getParamValue('fastaFilesDir');
    return 
"inputFileDir=$clusterWorkflowDataDir/$fastaFilesDir
";
}

sub getDistribJobTask {
  return "DJob::DistribJobTasks::MsaTask";
}
