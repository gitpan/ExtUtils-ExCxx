package ExtUtils::ExCxx;
require Exporter;
require DynaLoader;
@ISA       = qw(Exporter DynaLoader);
@EXPORT_OK = qw(&set_tryblock &nest);
$VERSION   = '0.02';

bootstrap ExtUtils::ExCxx;

1;
