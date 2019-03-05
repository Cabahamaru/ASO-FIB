#!/usr/bin/perl

use strict;

my $numArgs = @ARGV;

my $p=0;

my $usage="Usage: BadUsers.pl [-p] \n";
#detecció de l'opció d'entrada i control d'errors
if ($numArgs != 0){

	if ($numArgs == 1){
		if ($ARGV[0] eq "-p" ){
			$p=1;
		} else {print $usage; exit(1);}
	} else {print $usage; exit(1);}
}

#obrir fitxer de passwd i guardar els usuaris
my $pass_db_file="/etc/passwd";

open (FILE,$pass_db_file) or die "no es pot obrir el fitxer $pass_db_file: $!";

my @password_db=<FILE>;

close FILE;

my %invalid_users;
my $user_id;
my $user_home;
my $find_out;
my $user_line;

#recorregut de la llista d'usuaris
foreach $user_line (@password_db){

	chomp $user_line; #eliminar el salt de línia

	my @fields = split(':',$user_line);
	
	$user_id = $fields[0];

	$user_home = $fields[5];

	if ( -d $user_home ){

		my $command = sprintf("find %s -type f -user %s | wc -l", $user_home, $user_id);
		
		$find_out = `$command`;

		chomp $find_out;
	}else{
		$find_out = 0;
	}

	if ($find_out == 0){
		$invalid_users{$user_id}="invalid";
	}
}

#use Data::Dumper;
#print Dumper(\%invalid_users);

my $process_list_line;
my $user_proc;

if ( $p == 1) {
	
	my @process_list=`ps aux --no-headers`;

	foreach $process_list_line (@process_list) {
		
		chomp($process_list_line);

		my @fields_proc = split("\s* \s*","$process_list_line");

		$user_proc = $fields_proc[0];

		delete($invalid_users{$user_proc});
	}
}

my $user_inv_id;

foreach $user_inv_id (sort((keys%invalid_users))) {
	print "$user_inv_id\n";
}



