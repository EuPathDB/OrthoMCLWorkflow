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
  my $domainsDownloadFileName = "$websiteFilesDir/$downloadSiteDir/domainFreqs_$project-$release.txt";
  my $pairsDownloadDirName = "$websiteFilesDir/$downloadSiteDir/pairs_$project-$release";

  if ($undo) {
    $self->runCmd($test, "rm $seqsDownloadFileName.gz");
    $self->runCmd($test, "rm $deflinesDownloadFileName.gz");
    $self->runCmd($test, "rm $groupsDownloadFileName.gz");
    $self->runCmd($test, "rm $domainsDownloadFileName.gz");
    $self->runCmd($test, "rm -r $pairsDownloadDirName.tar.gz");
  } else {

    # fasta
    my $sql = $self->getSql(1);
    $self->runCmd($test, "gusExtractSequences --outputFile $seqsDownloadFileName --idSQL \"$sql\"");
    $self->runCmd($test, "gzip $seqsDownloadFileName");

    # deflines
    $sql = $self->getSql(0);
    $self->runCmd($test, "gusExtractSequences --outputFile $deflinesDownloadFileName --idSQL \"$sql\" --noSequence");
    $self->runCmd($test, "gzip $deflinesDownloadFileName");

    # domain frequencies
    my $extDbRlsId = $self->getExtDbRlsId($test, "PFAM|" . $self->getExtDbVersion($test, "PFAM"));
    $sql = $self->getDomainsSql($extDbRlsId);
    $self->runCmd($test, "makeFileWithSql --outFile $domainsDownloadFileName --sql \"$sql\"");
    $self->runCmd($test, "gzip $domainsDownloadFileName");

    # groups
    $self->runCmd($test, "cp $workflowDataDir/$groupsDir/groups.txt $groupsDownloadFileName");
    $self->runCmd($test, "gzip $groupsDownloadFileName");

    # pairs
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

sub getDomainsSql {
  my ($self, $extDbRlsId) = @_;

return "
SELECT name as Orthomcl_Group, primary_identifier as Pfam_Name, round(count(aa_sequence_id)/number_of_members,4) as Frequency from (
SELECT distinct og.name, db.primary_identifier, ogs.aa_sequence_id, og.number_of_members
FROM apidb.OrthologGroupAaSequence ogs,
apidb.OrthologGroup og,
dots.DomainFeature df,
dots.DbRefAaFeature dbaf,
sres.DbRef db
WHERE og.ortholog_group_id != 0 
AND ogs.ortholog_group_id = og.ortholog_group_id
AND df.aa_sequence_id = ogs.aa_sequence_id
AND dbaf.aa_feature_id = df.aa_feature_id
AND db.db_ref_id = dbaf.db_ref_id
and db.external_database_release_id = $extDbRlsId)
group by name, number_of_members, primary_identifier
ORDER BY name, frequency desc";
}
