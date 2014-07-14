 package OrthoMCLWorkflow::Main::WorkflowSteps::MakeWebservicesBlastFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

 sub run {
   my ($self, $test, $undo) = @_;

   my $downloadsDir = $self->getParamValue('downloadSiteDir');
   my $webservicesDir = $self->getParamValue('webServicesDir');
   my $release = $self->getParamValue('release');
   my $project = $self->getParamValue('project');

   my $websiteFilesDir = $self->getSharedConfig('websiteFilesDir');

   my $ncbiBlastPath = $self->getConfig('ncbiBlastPath');

   my $workflowDataDir = $self->getWorkflowDataDir();

   my $webSvcDir = "$websiteFilesDir/$project/$release/real/$webservicesDir";
   my $seqsDownloadFileName = "$websiteFilesDir/$downloadsDir/aa_seqs_$project-$release.fasta";


   if ($undo) {
     $self->runCmd(0, "rm -rf $webSvcDir/blast");
   } else {
     $self->runCmd($test,"mkdir $webSvcDir/blast");
     $self->runCmd($test,"cp $seqsDownloadFileName $webSvcDir/blast/proteinSeqs.gz");
     $self->runCmd($test,"gunzip $webSvcDir/blast/proteinSeqs.gz");
     $self->runCmd($test,"$ncbiBlastPath/formatdb -i $webSvcDir/blast/proteinSeqs -p T");
     $self->runCmd($test,"grep \> $webSvcDir/blast/proteinSeqs | wc > $webSvcDir/blast/proteinSeqs.count");
     $self->runCmd($test,"rm $webSvcDir/blast/proteinSeqs");
   }
 }


