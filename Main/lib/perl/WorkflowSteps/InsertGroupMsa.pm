package OrthoMCLWorkflow::Main::WorkflowSteps::InsertGroupMsa;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $inputDir = $self->getParamValue('inputDir'); # should contain cluster results, eg, be master/mainresult
  my $dataDir = $self->getParamValue('dataDir');

  my $workflowDataDir = $self->getWorkflowDataDir();

  $self->testInputFile('inputDir', "$workflowDataDir/$inputDir");

  my $tmpUnzipDir = "$workflowDataDir/$dataDir/tmp";

  # untar the results into tmp dir
  if (!$undo && !$test) {

    # remove old tmp dir if exists
    my $cmd = "rm -r $tmpUnzipDir";
    $self->runCmd($test, $cmd)  if -x $tmpUnzipDir;  #delete previously made, if there

    chdir "$workflowDataDir/$inputDir";
    opendir(DIR, "$workflowDataDir/$inputDir") || die "Can't open directory '$workflowDataDir/$inputDir'";
    while (my $file = readdir (DIR)) {
      next if ($file eq "." || $file eq "..");
      $self->runCmd($test, "tar -C $tmpUnzipDir -zxf $file");
    }
    closedir(DIR);
  }

  my $args = "--msaDir $tmpUnzipDir --fileRegex '(\S+)\.msa'";

  $self->runPlugin($test, $undo, "OrthoMCLData::Load::Plugin::UpdateOrthGroupWithMsa", $args);

  #remove tmp dir
  my $cmd = "rm -r $tmpUnzipDir";
  (system($cmd) || die "Error running '$cmd' \n$?") if -x $tmpUnzipDir;  #delete previously made, if there

}
