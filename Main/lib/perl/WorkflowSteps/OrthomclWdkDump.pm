package OrthoMCLWorkflow::Main::WorkflowSteps::OrthomclWdkDump;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $wdkDumpDir = $self->getWorkflowDataDir()."/wdkDump";

  if ($undo) {
      $self->runCmd(0, "rm -rf $wdkDumpDir") if -e "$wdkDumpDir";
  } else {
      my $cmd = "mkdir $wdkDumpDir";
      $self->runCmd(0, $cmd);
      my $groupSqlFile = writeSqlFile($wdkDumpDir,"Group");
      my $sequenceSqlFile = writeSqlFile($wdkDumpDir,"Sequence");
      $cmd = "loadDetailTable -record GroupRecordClasses.GroupRecordClass -sqlFile $groupSqlFile -detailTable apidb.GroupDetail -model OrthoMCL -field 'Sequences','PFams','EcNumber','GroupName'";
      $self->runCmd($test, $cmd);
      $cmd = "loadDetailTable -record SequenceRecordClasses.SequenceRecordClass -sqlFile $sequenceSqlFile -detailTable apidb.OrthomclSequenceDetail -model OrthoMCL -field 'Product','Taxon','PFamDomains','EcNumbers','OrthologGroupId'";
    $self->runCmd($test, $cmd);
    if ($test) {
      $self->runCmd(0, "rm -rf $wdkDumpDir");
    }
  }
}

sub writeSqlFile {
    my ($dir,$type) = @_;
    my $fileName = $dir."/".$type.".sql";
    my $sql;
    if ($type eq "Group") {
	$sql = "SELECT name AS group_name FROM Apidb.OrthologGroup WHERE core_peripheral IN ('P','R');";
    } elsif ($type eq "Sequence") {
	$sql = "SELECT secondary_identifier AS full_id FROM dots.ExternalAaSequence;";
    } else {
	die "The WDK Dump type must be 'Group' or 'Sequence'. It is currently: '$type'\n";
    }
    open(OUT,">",$fileName) or die "Cannot open '$fileName' for writing.\n";
    print OUT $sql."\n";
    close OUT;
    return ($fileName);
}
