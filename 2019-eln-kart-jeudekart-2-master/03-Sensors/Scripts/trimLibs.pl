# filename:          trimLibs.vhd
# kind:              VHDL file
# first created:     29.01.2005
# created by:        Laurent Gauch & Corthay Francois
################################################################################
# History:
# V0.1 : gal ??.??.???? -- Initial release
# V0.2 : cof ??.??.???? -- Improvements
# V0.3 : zas 10.06.2011 -- Replaces
#                          library xxx;use xxx.yyy.all;
#                          with                          
#                          --library xxx;
#                          use work.yyy.all;
# V0.4 : zas 23.01.2012 -- Replaces $env_var_name by the value of the found 
#                          environemnt variable.
#                          Mostly used to replace $SIMULATION_DIR for initialise
#                          bram's from a file placed in the Simulation Directory
# V0.5 : zas 02.02.2012 -- Write the output into a new files with the name
#                          defined in the $DESIGN_NAME variable
# V0.6 : zas 27.04.2012 -- Bugfix on feature added in version V0.3
# V0.7 : zas 07.11.2012 -- Modified rules for comment "FOR ALL"  lines
#                       -- More lines will be commented now, all lines containing
#                       -- FOR xxx : yyy USE ENTITIY zzz;
################################################################################
# Description: 
# Comment regular libraries in an concatenated file
# Help Parameter : <?>
# Parameter : <Input File Name> <Output File Name>
################################################################################

$separator = '-' x 79;
$indent = ' ' x 2;
$hdlInFileSpec = $ARGV[0];
$hdlOutFileSpec = $ENV{DESIGN_NAME} . '.vhd';

$verbose = 1;


#-------------------------------------------------------------------------------
# program I/O files
#
$tempFileSpec = $hdlOutFileSpec . '.tmp';

if ($verbose == 1) {
  print "\n$separator\n";
  print "Trimming library declarations from $hdlInFileSpec to $hdlOutFileSpec\n";
  print $indent, "temporary file spec: $tempFileSpec\n";
}


#-------------------------------------------------------------------------------
# read original file, edit and save to temporary file
#
#sleep(3);

my $line;

open(HDLFile, $hdlInFileSpec) || die "couldn't open $HDLFileSpec!";
open(tempFile, ">$tempFileSpec");
while (chop($line = <HDLFile>)) {
  # Comment libraries which aren't ieee
  if ($line =~ m/library/i) {
    if ( not($line =~ m/ieee/i) ) {
      $line = '-- ' . $line;
    }
  }
  
  # Replace use xxx.yyy with use work.yyy, except xxx is ieee or std
  if ($line =~ m/use\s.*\.all\s*;/i) {
    if ( not($line =~ m/\bieee\./i) and not($line =~ m/\bstd\./i)) {
      # 20120427 -- zas -- detect if there is any char before "use" except \s then insert new line \n
      if ( $line =~ m/[^\s]\s*use/i ) {
        $line =~ s/use\s+.*?\./\nuse work./i;
      }
      else {
        $line =~ s/use\s+.*?\./use work./i;
      }
    }
  }
  
  # Comment "FOR xxxx : yyy USE ENTITY zzz;
  if ($line =~ m/for\s+.+:.+\s+use\s+entity/i) {
    $line = '-- ' . $line;
  }
  
  # 20120124 -- zas -- Search for $Env_Var_Names and replace by the value of the env_var
  if ($line =~ m/(\$[^\s\/."\\]+)/i) {
    $envvar = $1;
    $envvar =~ s/^.//;
    $line =~ s/\$$envvar/$ENV{$envvar}/;
    
  }
  
  print tempFile ("$line\n");
}

close(tempFile);
close(HDLFile);


#-------------------------------------------------------------------------------
# delete original file and rename temporary file
#
unlink($hdlOutFileSpec);
rename($tempFileSpec, $hdlOutFileSpec);

if ($verbose == 1) {
  print "$separator\n";
}


#if ($verbose == 1) {
#  print $indent, "Hit any <CR> to continue";
#  $dummy = <STDIN>;
#}
