package OrthoMCLWorkflow::Main::WorkflowSteps::GetOldReleasesSequenceFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  # iterate through previous releases download dirs
  # for each release, find seq fasta file
  # in outputDir make dir for that release
  # read seq file.  for each taxon write out a file into the release's output dir, gzip it.


  my $inputDir = $self->getParamValue('inputDir');  # download site dir including all previous releases (but not the one we are building)
  my $outputDir = $self->getParamValue('outputDir'); # where to put th 

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $fromDir = "$workflowDataDir/$inputDir";
  my $targetDir = "$workflowDataDir/$outputDir";

  $self->testInputFile('inputDir', $fromDir);

  if ($undo) {
    $self->runCmd(0,"rm -r $targetDir");
  } else {
    $self->runCmd(0, "mkdir $targetDir");

    chdir $fromDir || $self->error("can't chdir to '$fromDir' \n $?");
    my @files = <*/*.fasta.gz>;
    $self->error("Can't find previous release fasta files") unless scalar(@files) > 3;
    foreach my $file (@files) {
      $file =~ /(\d+)\.fasta\.gz/ || $self->error("Fasta file '$fromDir/$file' does not conform to the pattern \\d+.fasta.gz");
      my $version = $1;
      $self->runCmd(0, "mkdir $targetDir/$version");
      open(IN, $file) || $self->error("Can't open file '$file'");
    }
    opendir(DIR, "$workflowDataDir/$inputDir") || die "Can't open directory '$workflowDataDir/$inputDir'";
    while (my $file = readdir (DIR)) {
      next if ($file eq "." || $file eq "..");
      $mgr->runCmd("tar -C $tmpUnzipDir -zxf $file");
    }
    closedir(DIR);
  }

}
