package OrthoMCLWorkflow::Main::WorkflowSteps::ExtractGroupFasta;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use File::Basename;


sub run {
    my ($self, $test, $undo) = @_;

    my $workflowDataDir = $self->getWorkflowDataDir();

    my $outputDir = $self->getParamValue('outputDir');
    my $tarAndZip = $self->getBooleanParamValue('tarAndZip');
    my $groupTypesCPR = $self->getParamValue('groupTypesCPR');
    my $tarSize = $self->getParamValue('proteinsPerTarFile');

    if ($undo) {
	$self->runCmd($test, "rm -r $workflowDataDir/$outputDir") if -e "$workflowDataDir/$outputDir";
	$self->runCmd($test, "rm -r $workflowDataDir/$outputDir.tar.gz") if $tarAndZip;
    } else{
      if ($test) {
	$self->runCmd(0, "mkdir $workflowDataDir/$outputDir") unless $tarAndZip;
	$self->runCmd(0, "touch $workflowDataDir/$outputDir.tar.gz") if $tarAndZip;
      } else {
	$self->runCmd($test, "extractGroupFastaFiles --outputDir $workflowDataDir/$outputDir --groupTypesCPR $groupTypesCPR --tarBall $tarSize"); #seqs per tarball, regardless of how many groups
	my($baseDir, $path, $suffix) = fileparse("$workflowDataDir/$outputDir");
	chdir "$path" || die "can't chdir to '$path'\n";
	$self->runCmd($test, "tar -zcf $baseDir.tar.gz $baseDir") if $tarAndZip;
 	$self->runCmd($test, "rm -r $workflowDataDir/$outputDir") if ($tarAndZip && -e "$workflowDataDir/$outputDir");
     }
    }
}
