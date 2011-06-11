use Test::More tests => 2;
require File::Temp;

my $file = File::Temp::tmpnam();
END { unlink $file };

system
    $^X,
        '-Mblib',
        '-MDevel::ContinuousProfiler',
        '-MData::Dumper',
        '-e' => '1 for 1 .. 1_000_000; open STDOUT, ">", "' . $file . '" or die "Cant write to ' . $file . ': $!"; print Data::Dumper::Dumper(\%Devel::ContinuousProfiler::DATA)';
is( $?, 0 );
open my $fh, '<', $file or warn "Can't open $file: $!";
$/ = undef;
my $data = readline $fh;
unlink $file;

diag( $data );
ok( eval $data );
