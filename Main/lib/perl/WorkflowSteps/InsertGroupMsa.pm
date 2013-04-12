sub loadMsaResultFiles {
  my ($mgr,$dir,$regex,$untar) = @_;

  my $propertySet = $mgr->{propertySet};
  my $signal = "loadMsaResult";

  return if $mgr->startStep("load MSA results", $signal);

  my $msaDir = "$mgr->{dataDir}/msa/$dir";

  $mgr->runCmd("mkdir -p $msaDir");

  if ($untar) {

    chdir "$mgr->{dataDir}/msa/master/mainresult/";

    opendir(DIR, "$mgr->{dataDir}/msa/master/mainresult/") || die "Can't open directory '$mgr->{dataDir}/msa/master/mainresult/'";

    while (my $file = readdir (DIR)) {

      next if ($file eq "." || $file eq "..");

      $mgr->runCmd("tar -C $msaDir -zxf $file");
    }

    closedir(DIR);
  }

  my $args = "--msaDir $mgr->{dataDir}/msa/$dir --fileRegex \"$regex\" ";

  $mgr->runPlugin($signal,
		  "OrthoMCLData::Load::Plugin::UpdateOrthGroupWithMsa", $args,
		  "Updating rows in apidb.orthologgroup from msa files");
}
