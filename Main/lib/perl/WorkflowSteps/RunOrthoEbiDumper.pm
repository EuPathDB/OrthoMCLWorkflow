package OrthoMCLWorkflow::Main::WorkflowSteps::RunOrthoEbiDumper;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $ebiFtpUser = $self->getConfig('ebiFtpUser');
  my $ebiFtpPassword = $self->getConfig('ebiFtpPassword');
  my $orthomclAbbrev = $self->getParamValue('orthomclAbbrev');
  my $ebiVersion = $self->getParamValue('ebiVersion');
  my $ebiOrganismName = $self->getParamValue('ebiOrganismName');
  my $outputDir = $self->getParamValue('outputDir');
  my $project_name = $self->getParamValue('projectName');
  my $ecFileName = $self->getParamValue('ecFileName');
  my $proteomeFileName = $self->getParamValue('proteomeFileName');

  my $workflowDataDir = $self->getWorkflowDataDir();
  $outputDir = "$workflowDataDir/$outputDir";
  my $unpackDir = "$outputDir/unpack";
  my $initSqlDir = "$outputDir/sql";
  my $mysqlDir = "$outputDir/mysql_data";

  my $cmd = "orthoEbiDumper.pl -init_directory $initSqlDir --mysql_directory $mysqlDir --output_directory $outputDir --container_name $orthomclAbbrev --orthomclAbbrev $orthomclAbbrev --proteome_file_name $proteomeFileName --ec_file_name $ecFileName";

  if ($undo) {
    $self->runCmd(0, "rm -rf $mysqlDir");
    $self->runCmd(0, "rm -rf $initSqlDir");
    $self->runCmd(0, "rm -rf $unpackDir");
    $self->runCmd(0, "rm $outputDir/$proteomeFileName");
    $self->runCmd(0, "rm $outputDir/$ecFileName");
  } else {
    $self->runCmd($test, "mkdir -p $mysqlDir");
    $self->runCmd($test, "mkdir -p $unpackDir");
    $self->runCmd($test, "mkdir -p $initSqlDir");
    $self->runCmd($test,"wget --ftp-user ${ebiFtpUser} --ftp-password ${ebiFtpPassword} -O ${unpackDir}/init.sql.gz ftp://ftp-private.ebi.ac.uk:/EBIout/${ebiVersion}/coredb/${project_name}/${ebiOrganismName}*.gz");
    $self->runCmd($test,"gunzip -c ${unpackDir}/init.sql.gz >${initSqlDir}/init.sql");

    $self->runCmd($test,$cmd);
  }
}

1;

