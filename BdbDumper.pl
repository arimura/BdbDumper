use strict ;
use warnings;

use BerkeleyDB;
use Data::Dumper;
use Data::MessagePack;
use Getopt::Long;

use vars qw( $file %h $k $v ) ;

GetOptions(
    "file=s" => \$file
) or die("invalid options");

die("No DBD file specified") unless $file; 

tie %h, "BerkeleyDB::Btree",
            -Filename => $file,
            -Flags    => DB_CREATE
    or die "Cannot open file $file: $! $BerkeleyDB::Error\n" ;

while (($k, $v) = each %h){
    next if grep /$k/, ('baker_version', 'current_revision');
    my ($head, $body) = split /\r\n/, $v;
    printf "key : %s\n", $k;
    print Dumper(Data::MessagePack->unpack($body));
    print "\n";
}

untie %h;

1;
