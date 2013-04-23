package OrthoMCLWorkflow::Main::WorkflowSteps::MakeDownloadFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $downloadSiteDir = $self->getParamValue('downloadSiteDir');
  my $release = $self->getParamValue('release');
  my $project = $self->getParamValue('project');
  my $groupsDir = $self->getParamValue('inputGroupsDir');

  $self->testInputFile('groupsDir', "$workflowDataDir/$groupsDir");

  my $websiteFilesDir = $self->getSharedConfig('websiteFilesDir');

  my $seqsDownloadFileName = "$websiteFilesDir/$downloadSiteDir/aa_seqs_$project-$release.fasta";
  my $deflinesDownloadFileName = "$websiteFilesDir/$downloadSiteDir/deflines_$project-$release.fasta";
  my $groupsDownloadFileName = "$websiteFilesDir/$downloadSiteDir/groups_$project-$release.txt";
  my $pairsDownloadDirName = "$websiteFilesDir/$downloadSiteDir/pairs_$project-$release";

  if ($undo) {
    $self->runCmd($test, "rm $seqsDownloadFileName.gz");
    $self->runCmd($test, "rm $deflineDownloadFileName.gz");
    $self->runCmd($test, "rm $groupsFileName.gz");
    $self->runCmd($test, "rm -r $pairsDir.tar.gz");
  } else {
    my $sql = $self->getSql(1);
    $self->runCmd($test, "gusExtractSequences --outputFile $seqsDownloadFileName --idSQL \"$sql\"");
    $self->runCmd($test, "gzip $seqsDownloadFileName");

    $sql = $self->getSql(0);
    $self->runCmd($test, "gusExtractSequences --outputFile $deflinesDownloadFileName --idSQL \"$sql\" --noSequence");
    $self->runCmd($test, "gzip $deflinesDownloadFileName");

    $self->runCmd($test, "cp $workflowDataDir/$groupsDir/groups.txt $groupsDownloadFileName");
    $self->runCmd($test, "gzip $groupsDownloadFileName");

    $self->runCmd($test, "cp -r $workflowDataDir/$groupsDir/pairs $websiteFilesDir/$downloadSiteDir/$pairsDownloadDirName");
    $self->runCmd($test, "tar -czf $websiteFilesDir/$downloadSiteDir/$pairsDownloadDirName.tar.gz $websiteFilesDir/$downloadSiteDir/$pairsDownloadDirName");
  }
}

sub getSql {
  my ($self, $seq) = @_;

  my $SS = $seq? ", x.sequence" : "";
return "
select ot.three_letter_abbrev || '|' || x.source_id || ' | ' ||
                   CASE WHEN og.name is null THEN 'no_group' ELSE  og.name END || ' | '  || x.description$SS
                   from dots.externalaasequence x, apidb.orthomcltaxon ot, apidb.orthologgroup og,
                   apidb.orthologgroupaasequence oga
                   where ot.taxon_id = x.taxon_id and x.aa_sequence_id = oga.aa_sequence_id(+)
                   and oga.ortholog_group_id = og.ortholog_group_id(+)
";
}
