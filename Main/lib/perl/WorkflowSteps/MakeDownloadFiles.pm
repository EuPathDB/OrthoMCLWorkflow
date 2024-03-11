package OrthoMCLWorkflow::Main::WorkflowSteps::MakeDownloadFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $relativeDownloadSiteDir = $self->getParamValue('relativeDownloadSiteDir');
  my $release = $self->getParamValue('release');
  my $project = $self->getParamValue('project');
  my $coreGroupsFile = $self->getParamValue('coreGroupsFile');
  my $residualGroupsFile = $self->getParamValue('residualGroupsFile');
  my $orthomclVersion = $self->getParamValue('orthomclVersion');
  $orthomclVersion =~ s/_//g;
  my $groupFile = "$workflowDataDir/genomicSitesFiles_$orthomclVersion/orthomclGroups.txt";

  #original for core plus periph proteomes build $self->testInputFile('groupsFile', "$workflowDataDir/finalGroups.txt");
  $self->testInputFile('groupsFile', "$workflowDataDir/coreGroups/orthomclGroups.txt");

  my $websiteFilesDir = $self->getWebsiteFilesDir($test);

  my $seqsDownloadFileName = "$websiteFilesDir/$relativeDownloadSiteDir/aa_seqs_$project-$release.fasta";
  my $deflinesDownloadFileName = "$websiteFilesDir/$relativeDownloadSiteDir/deflines_$project-$release.txt";
  my $groupsDownloadFileName = "$websiteFilesDir/$relativeDownloadSiteDir/groups_$project-$release.txt";
  my $domainsDownloadFileName = "$websiteFilesDir/$relativeDownloadSiteDir/domainFreqs_$project-$release.txt";
  my $genomeSummaryFileName = "$websiteFilesDir/$relativeDownloadSiteDir/genomeSummary_$project-$release.txt";
  my $corePairsDownloadDir = "$websiteFilesDir/$relativeDownloadSiteDir/coreGroups_$project-$release";
  my $residualPairsDownloadDir = "$websiteFilesDir/$relativeDownloadSiteDir/residualGroups_$project-$release";

  if ($undo) {
    $self->runCmd($test, "rm $seqsDownloadFileName.gz");
    $self->runCmd($test, "rm $deflinesDownloadFileName.gz");
    $self->runCmd($test, "rm $groupsDownloadFileName.gz");
    $self->runCmd($test, "rm $domainsDownloadFileName.gz");
    $self->runCmd($test, "rm $genomeSummaryFileName.gz");
    $self->runCmd($test, "rm -r $corePairsDownloadDir");
    $self->runCmd($test, "rm -r $residualPairsDownloadDir");

  } else {

    # fasta
    my $sql = $self->getSql(1);
    $self->runCmd($test, "mkdir -p $websiteFilesDir/$relativeDownloadSiteDir");
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
    # original for core plu periph proteomes $self->runCmd($test, "cp $workflowDataDir/finalGroups.txt $groupsDownloadFileName");
    $self->runCmd($test, "cp $groupFile $groupsDownloadFileName");
    $self->runCmd($test, "gzip $groupsDownloadFileName");

    # genome summary
    $sql = $self->getGenomeSummarySql();
    $self->runCmd($test, "makeFileWithSql --outFile $genomeSummaryFileName --sql \"$sql\" --includeHeader --outDelimiter \"\\t\"");
    $self->runCmd($test, "gzip $genomeSummaryFileName");

    # pairs
    $self->runCmd($test, "mkdir -p $corePairsDownloadDir");
    $self->runCmd($test, "cp $workflowDataDir/$coreGroupsFile $corePairsDownloadDir");
    $self->runCmd($test, "gzip $corePairsDownloadDir/*");
    $self->runCmd($test, "mkdir -p $residualPairsDownloadDir");
    $self->runCmd($test, "cp $workflowDataDir/$residualGroupsFile $residualPairsDownloadDir");
    $self->runCmd($test, "gzip $residualPairsDownloadDir/*");
  }
}

sub getSql {
  my ($self, $seq) = @_;

  my $SS = $seq? ", x.sequence" : "";
return "
SELECT x.secondary_identifier, og.group_id, x.description, x.sequence
FROM dots.orthoaasequence x, apidb.orthologgroup og, apidb.orthologgroupaasequence oga
WHERE x.aa_sequence_id = oga.aa_sequence_id(+) and oga.group_id = og.group_id(+) and og.IS_RESIDUAL in (0,1)
";

}

sub getDomainsSql {
  my ($self, $extDbRlsId) = @_;

return "
SELECT name as Orthomcl_Group, primary_identifier as Pfam_Name, round(count(aa_sequence_id)/number_of_members,4) as Frequency                                                                             FROM ( 
    SELECT distinct og.group_id as name, db.primary_identifier, ogs.aa_sequence_id, q.number_of_members                                                                                                       FROM 
     apidb.OrthologGroupAaSequence ogs, apidb.OrthologGroup og, dots.DomainFeature df, dots.DbRefAaFeature dbaf, sres.DbRef db, 
        (SELECT group_id, count(aa_sequence_id) as number_of_members 
            from apidb.orthologgroupaasequence GROUP BY group_id) q
    WHERE og.ortholog_group_id != 0 
    AND ogs.group_id = og.group_id 
    AND ogs.group_id = q.group_id                                                                                                            
    AND og.is_residual in (0,1) AND df.aa_sequence_id = ogs.aa_sequence_id                                                                                                        
    AND dbaf.aa_feature_id = df.aa_feature_id AND db.db_ref_id = dbaf.db_ref_id                                                                                                                    
    AND db.external_database_release_id = $extDbRlsId)
GROUP BY name, number_of_members, primary_identifier                                     
ORDER BY name, frequency desc
"
}

sub getGenomeSummarySql {
    my ($self) = @_;

    return "
SELECT ot.name, ot.three_letter_abbrev,
       case ot.core_peripheral when 'C' then 'Core' when 'P' then 'Peripheral' else '' end as core_peripheral,
       od.resource_name, od.resource_url
FROM apidb.OrthomclTaxon ot, apidb.OrthomclResource od
WHERE od.orthomcl_taxon_id(+) = ot.orthomcl_taxon_id
       AND ot.is_species != 0 
ORDER BY ot.name";
}
