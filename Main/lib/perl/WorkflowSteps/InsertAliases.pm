package OrthoMCLWorkflow::Main::WorkflowSteps::InsertAliases;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $externalDatabase = $self->getParamValue('externalDatabase');
    my $aliasesFile = $self->getParamValue('aliasesFile');
    my $fileFullPath = "$workflowDataDir/$aliasesFile";

    my $args = "--DbRefMappingFile $fileFullPath --extDbName $externalDatabase --extDbReleaseNumber dontcare --columnSpec 'primary_identifier,remark' --tableName AASequenceDbRef";

    $self->testInputFile('aliasesFile', "$fileFullPath");
    $self->runPlugin($test, $undo, "ApiCommonData::Load::Plugin::InsertDBxRefs", $args);

}
