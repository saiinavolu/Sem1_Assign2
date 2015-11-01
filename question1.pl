#!/usr/local/bin/perl

	my $string;
	my $sequence;
	my %codonmap;
	my %dinucleotidemap;
	my @keys;
	my @values;
	my $proteintranslation;
	my $flag = 0;
	my %codontable = (
                "UCA" => "S", 
                "UCC" => "S", 
                "UCG" => "S", 
                "UCU" => "S", 
                "UUC" => "F", 
                "UUU" => "F", 
                "UUA" => "L", 
                "UUG" => "L", 
                "UAC" => "Y", 
                "UAU" => "Y", 
                "UAA" => "_", 
                "UAG" => "_", 
                "UGC" => "C", 
                "UGU" => "C", 
                "UGA" => "_", 
                "UGG" => "W", 
                "CUA" => "L", 
                "CUC" => "L", 
                "CUG" => "L", 
                "CUU" => "L", 
                "CCA" => "P", 
                "CAU" => "H", 
                "CAA" => "Q", 
                "CAG" => "Q", 
                "CGA" => "R", 
                "CGC" => "R", 
                "CGG" => "R", 
                "CGU" => "R", 
                "AUA" => "I", 
                "AUC" => "I", 
                "AUU" => "I", 
                "AUG" => "M", 
                "ACA" => "T", 
                "ACC" => "T", 
                "ACG" => "T", 
                "ACU" => "T", 
                "AAC" => "N", 
                "AAU" => "N", 
                "AAA" => "K", 
                "AAG" => "K", 
                "AGC" => "S", 
                "AGU" => "S", 
                "AGA" => "R", 
                "AGG" => "R", 
                "CCC" => "P", 
                "CCG" => "P", 
                "CCU" => "P", 
                "CAC" => "H", 
                "GUA" => "V", 
                "GUC" => "V", 
                "GUG" => "V", 
                "GUU" => "V", 
                "GCA" => "A", 
                "GCC" => "A", 
                "GCG" => "A", 
                "GCU" => "A", 
                "GAC" => "D", 
                "GAU" => "D", 
                "GAA" => "E", 
                "GAG" => "E", 
                "GGA" => "G", 
                "GGC" => "G", 
                "GGG" => "G", 
                "GGU" => "G"  	
		);
	open(READFILE,'buddi.fna');
	while (<READFILE>)
	{ 
		chomp;
		if($flag == 1)
		{
			$string = "$_";
			$sequence = $sequence.$string;
		}
		$flag = 1;
	}
#	print "Before : ".$sequence."\n";
	$sequence =~ tr/T/U/;
#	print "After : ".$sequence."\n";
	$sequencelength = length($sequence);

	$codonlength = $sequencelength - $sequencelength%3;

	for($j=0;$j<$codonlength;$j=$j+3)
	{

		$codon = substr $sequence, $j, 3;
		$proteintranslation = $proteintranslation.$codontable{$codon};
		if(exists $codonmap{$codon})
		{
			$codonmap{$codon} = $codonmap{$codon} + 1;
		}
		else
		{
			$codonmap{$codon} = 1;
		}
	}
	
	print "\n".$proteintranslation."\n\n";

	@keys = keys %codonmap;
	@values = values %codonmap;

	open (CODONFILE, '>codon.txt'); 

	for($i=0;$i<@keys;$i++)
	{
#		print $keys[$i]." = ".$values[$i]."\n";
		print CODONFILE $keys[$i]." = ".$values[$i]."\n";
	}

	close (CODONFILE);

	$dinucleotidelength = $sequencelength - $sequencelength%2;
	for($j=0;$j<$dinucleotidelength;$j=$j+2)
	{
		$dinucleotide = substr $sequence, $j, 2;
		if(exists $dinucleotidemap{$dinucleotide})
		{
			$dinucleotidemap{$dinucleotide} = $dinucleotidemap{$dinucleotide} + 1;
		}
		else
		{
			$dinucleotidemap{$dinucleotide} = 1;
		}
	}

	@keys = keys %dinucleotidemap;
	@values = values %dinucleotidemap;

	open (DINUCLEOTIDEFILE, '>dinucleotide.txt'); 

	for($i=0;$i<@keys;$i++)
	{
#		print $keys[$i]." = ".$values[$i]."\n";
		print DINUCLEOTIDEFILE $keys[$i]." = ".$values[$i]."\n";
	}

	close (DINUCLEOTIDEFILE);
	
	close (READFILE);
