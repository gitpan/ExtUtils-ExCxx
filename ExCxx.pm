package ExtUtils::ExCxx;
require Exporter;
require DynaLoader;
@ISA       = qw(Exporter DynaLoader);
@EXPORT_OK = qw(&set_tryblock);
$VERSION   = '0.01';

bootstrap ExtUtils::ExCxx;

1;
