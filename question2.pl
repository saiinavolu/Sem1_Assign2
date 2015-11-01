#!/usr/local/bin/perl

	my $string;
	my $sequence;
	my %codonmap;
	my %dinucleotidemap;
	my @keys;
	my @values;
	my $proteintranslation;
	my $flag = 0;
	my $flag1 = 0;
	my $orf;
	my $substart = 0;
	my $count = 0;
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
	open(READFILE,'L43967.fna');
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

	open(ORFFILE,'>orf.txt');

	for($i=0;$i<3;$i++)
	{
#		print "\nORFs in the iteration ".($i+1)."\n";
		print ORFFILE "\nORFs in the iteration ".($i+1)."\n";
		$flag1 = 0;
		for($j=$i;$j<$codonlength;$j=$j+3)
		{

			$codon = substr $sequence, $j, 3;
		
			if($codon eq 'AUG' && $flag1 == 0)
			{
				$flag1 = 1;
				$orf = "M";
			}
			elsif(($codon eq 'UAA' || $codon eq 'UAG' || $codon eq 'UGA') && $flag1 == 1)
			{
				$flag1 = 0;
				$count = $count + 1;
				print "ORF ".$count.":\n";
				print ORFFILE "ORF ".$count.":\n";
				$orflength = length($orf);
				while($orflength>80)
				{
					$suborf = substr $orf, $substart, 80;
					print $suborf."\n";
					print ORFFILE $suborf."\n";
					$substart = $substart + 80;
					$orflength = $orflength - 80;
				}
				$suborf = substr $orf, $substart;
				print $suborf."\n";
				print ORFFILE $suborf."\n";
				$substart = 0;
				$orf = "";
				$suborf = "";
				
			}
			elsif($flag1 == 1)
			{
				$orf = $orf.$codontable{$codon};
			}
		}
	}
	
#	print "\n".$proteintranslation."\n\n";

	close (ORFFILE);
	close (READFILE);
