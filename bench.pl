use ExtUtils::ExCxx qw(&set_tryblock &nest);
use Benchmark;

my $try = sub {
    nest(sub {
	eval '0';
    });
};

my $count = 100000;

my $cxx = timeit($count, $try);

set_tryblock(0);  #back to setjmp...

my $c = timeit($count, $try);

print "[ setjmp ] ".timestr($c)."\n";
print "[ cxx    ] ".timestr($cxx)."\n";
