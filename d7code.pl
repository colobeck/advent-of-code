#!/usr/bin/perl
use strict;
use warnings;

my $curLine="";
my $debug = 1;
my $lineNum=0;
my $numSelfContained;
my $token="";
my $token1="";
my $token2="";
my $cwd;
my $stackDepth=0;
my $lastCommand = "";
my $lastOutput = "FILE";
my $lastFileSize;
my $lastFileName;
my %d;
my @cwd;
my $cod;
my %fsizes;
my $maxFound = 0;
my $maxFolder = 0;


my%hash=(
  'key1'=>'val1',
  'key2'=>{
    'key21'=>'val21',
    'key22'=>'val22',
    'key23'=>{
      'key231'=>'val231',
      'key232'=>'val232',
    },
    'key24'=>'val24',
  },
  'key3'=>'val3',
);

#my %h=(
#   'root'=>1,
#   'root'=>{'a'=>2,'b'=>3,'c'=>{
#                            'dd'=>5,
# 'ee'=>6
#   }
#           }
#    );
#   

#&printhash(\%h);

#if ($debug) { print "line ",__LINE__,"\n"; }

while (<>)
{
chomp;
chop;
$curLine = $_; 
$lineNum++;

if ($debug) { print "line ",__LINE__,": curLine=|$curLine\|\n"; }


  my $currentLRVsearch = ".TLM_POINT..TLM_MNEMONIC.\"(.*)\".TLM.CONVERSION.*";  
  my $regexCD = ". cd (.*)";  
  my $regexLS = ". ls.*";  
  my $regexDIR = "dir (.*)";    
  my $regexFILE = "(.*) (.*)";      
  
  if ($curLine =~ $regexCD) 
  {
    $token = $1;
if ($debug) { print "**line ",__LINE__,": Found CD.  Token=|$token|\n"; }   
$lastCommand = "CD"; 
$lastOutput = ""; 
$token =~ s/^\s+|\s+$//g ;
if ($token eq "/") 
{ 
$cod = "root"; 
#@cwd = (); 
push(@cwd,$cod); print "\nPUSHROOT\n";
}
elsif ($token eq "..") 
{ 
$stackDepth--;
$cod = pop(@cwd); print "\nPOP $stackDepth\n";

}
else  
{ 
$stackDepth++;
$cod = $token; push(@cwd, $cod); print "\nPUSH $stackDepth\n";

}

my $cwdsize = scalar @cwd;
if ($debug) { print "**line ",__LINE__,": CWD size is $cwdsize\n"; }   


  }
  elsif ($curLine =~ $regexLS)  
  {
    #$token = $1;
if ($debug) { print "**line ",__LINE__,": Found LS.  \n"; }   
$lastCommand = "LS";
$lastOutput = "";
  }
  elsif ($curLine =~ $regexDIR) 
  {
    $token = $1;
if ($debug) { print "**line ",__LINE__,": Found DIR.  Token=|$token|\n"; }   
$lastOutput = "DIR";
$token =~ s/^\s+|\s+$//g ; 
$cod = $token;
$fsizes{$cod}+=0; 

  }
  elsif ($curLine =~ $regexFILE) 
  {
# a directory file listing
$token1 = $1;
$token2 = $2; 

$lastOutput = "FILE";
$lastFileSize = int($token1);
$lastFileName = $token2; 
if ($debug) { print "**line ",__LINE__,": FILE $token2 has Size=|$token1|\n"; }   
# if ($debug) { print "**line ",__LINE__,": FILE $token2 has Size=|$token1|\n"; }   
# $fsizes{$cod}+=$lastFileSize;
# if ($debug) { print "**line ",__LINE__,": adding to folder $cod, fsizes\{$cod\}=$fsizes{$cod}\n"; }   

# find parent dir(s) and sum it too. 
my $cwdsize = scalar @cwd;
if ($debug) { print "**line ",__LINE__,": CWD length is $cwdsize\n"; }   
if ($cwdsize > 0)
{
my $fullPath="";
#Create a full folder path
if ("hhh" eq "hhh")
{
for (my $m=0; $m < scalar @cwd; $m++)
{
$fullPath="";
for (my $i=0; $i<= $m; $i++)
{
$fullPath.=$cwd[$i];
}
$fsizes{$fullPath}+=$lastFileSize;
if ($debug) { print "**line ",__LINE__,": adding size to cwd sub $fullPath\n"; }   
} 
} 
else
{
#if @cwd is not root.
my @temp = @cwd; 
for (my $i = 0; $i < $cwdsize; $i++)
{
if ($debug) { print "**line ",__LINE__,": adding size to cwd sub $temp[$i]\n"; }   
$fsizes{$temp[$i]}+=$lastFileSize;
if ($lastFileSize > $maxFound) {$maxFound = $lastFileSize; }
if ($fsizes{$temp[$i]} > $maxFolder) {$maxFolder = $fsizes{$temp[$i]}; } 

}
}
}



  }
  #gather up data.

  
  if ($lastOutput eq "DIR")
  {
 
  }
  if ($lastOutput eq "FILE")
  {
 
  }

#$lastCommand = "";
#$lastOutput = "FILE";
#$lastFileSize = $token1;
#$lastFileName = $token2; 
#

#&printhash(\%d);

print "\n";
for (my $i=0; $i< scalar @cwd; $i++)
{
  print "$cwd[$i].";
}
print "\n";
  
} # End Main While
foreach my $ddir (sort (keys %fsizes))
{
print "fsizes\{$ddir\} = $fsizes{$ddir}\n";
}
#FINAL MOST 100,000
#my $arysize = $@fsizes;
print "\n\nMAX 100K\n";
my $sumtot=0;
foreach my $folder (sort (keys %fsizes))
{
if ($fsizes{$folder} <= 100000)
{
print "fsizes\{$folder\}=$fsizes{$folder} \n";
$sumtot+= $fsizes{$folder};
}


}
print "Sumtotal of max 100K folders: $sumtot \n";
print "stackdepth = $stackDepth \n";
print "maxFound = $maxFound\n";
print "maxFolder = $maxFolder\n";

$sumtot=0;
foreach my $folder (keys %fsizes)
{
if (int($fsizes{$folder}) <= 100000)
{
print "fsizes\{$folder\}=$fsizes{$folder} \n";
$sumtot+= $fsizes{$folder};
}
}


print "Sumtotal of max 100K folders: $sumtot \n";



print "\n\n\nPart 2\n";

foreach my $dsize (sort {$a <=> $b} (values %fsizes))
{
    #print "$dsize is the fsizes\n";
	printf "Dir Size = %10.10d\n",$dsize;
}

#	if (int($fsizes{$folder}) >= 8381165)



#Sumtotal of max 100K folders: 1338139 
#Sumtotal of max 100K folders: 1403112 
#Sumtotal of max 100K folders: 1490523 

sub printhash {
  my($refhash,$keysofar)=@_;
  print "\nPRINTB\n";
  for(sort keys%$refhash){
    if(ref$$refhash{$_}){
      printhash($$refhash{$_},$keysofar.$_.' => ');
    }else{
      print$keysofar,$_,' => ',$$refhash{$_},"\n";
    }
  }
  print "\nPRINTE\n";  
}


#sub printhash {
#my ($refhash)=@_;
# 
#  foreach(sort keys%$refhash){
#    if(ref $$refhash{$_}){
#      &printhash($$refhash{$_});
#    }else{
#      print"$_ => $$refhash{$_}\n";
#    }
#  }
#}
#
