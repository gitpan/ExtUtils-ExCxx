
$self->{CC}="cxx -xtaso";

$self->{LD}="ld -taso";
$self->{MAP_TARGET}="perl32";
$self->{LINKTYPE}="static";

check_cxx_version();

sub check_cxx_version {
	my $out=`cxx -V`;
	die "cant run cxx\n" if @?;
	return if $out=~/\QV5.5-004/;

	warn "$out\n";

 	die "Your compiler Version wont work\n" if $out=~/\QT5.6-009/;

	warn "Compiler version untested\n";
}


package MY;

sub c_o {
	my $out=shift->SUPER::c_o;

	# wish, joshua didn't call his C++ files .c. So we need to modify
	# our .c.o rule to tell cxx, that our .c files really are C++ source

	$out=~s/\$\*\.c/-x cxx \$*.c/;
	$out;
}

sub cflags {

	my $out=shift->SUPER::cflags(@_);
	#
	# DEC cxx5.5 doesn't know the -std flags, which we possibly used
	# to compile perl with cc. cxx 5.6 does.
	#
	$out=~s/-std//;             # cxx5.5-004 doesnt want this.
	$out;
}

sub top_targets {

	my $out=shift->SUPER::top_targets(@_);

	# add dependencies to automaticly make,install,clean
	# our perl32.

	<<'_EOF_'.$out;
all :: $(MAP_TARGET)
pure_install :: $(MAP_TARGET)
	$(MAKE) -f $(MAKE_APERL_FILE) pure_inst_perl
_EOF_
}


