#!./perl -w

use strict;
use ExtUtils::MakeMaker;

# Also see the ./hints directory!

#$Verbose = 1;
WriteMakefile
    (
     NAME         => 'ExtUtils::ExCxx',
#     PREREQ_PM	  => { Test => 0.02 },
     VERSION_FROM => 'ExCxx.pm',
     OPTIMIZE     => '-O2',
     'OBJECT'	=> join(' ', qw[ExCxx.o]),
     dist	=> {COMPRESS=>'gzip -9f', SUFFIX => 'gz'},
    );

__END__
