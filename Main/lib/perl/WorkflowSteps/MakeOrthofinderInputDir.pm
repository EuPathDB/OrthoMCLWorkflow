package OrthoMCLWorkflow::Main::WorkflowSteps::MakeOrthofinderInputDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $proteomesDir = join("/", $workflowDataDir, $self->getParamValue("proteomesDir"));
  my $outputDir = join("/", $workflowDataDir, $self->getParamValue("outputDir"));

  if ($undo) {
      $self->runCmd(0, "rm -rf $outputDir/fastas.tar.gz");
      $self->runCmd(0, "rm -rf $outputDir/fastas/*");
  }
  elsif ($test) {
      $self->runCmd(0, "echo 'test' > $outputDir/fastas/test.fasta");
      $self->runCmd(0, "tar -zcvf fastas.tar.gz $outputDir/fastas");
  }
  else {
   
      opendir(DIR, $proteomesDir) || die "Can't open input directory '$proteomesDir'\n";
          my @fastas = readdir('DIR');
      closedir(DIR);
      die "Input directory $proteomesDir does not contain any fastas" unless scalar(@fastas);

      $self->runCmd(0, "cp ${proteomesDir}/*.fasta $outputDir/fastas/");
      $self->runCmd(0, "tar -zcvf $outputDir/fastas.tar.gz $outputDir/fastas");
  }
}

1;
