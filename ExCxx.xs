/*
Copyright © 1997-1998 Joshua Nathaniel Pritikin.  All rights reserved.
This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
*/

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __GNUG__
#undef __attribute__
#define __attribute__(_arg_)
/* This directive is used by gcc to do extra argument checking.  It
has no affect on correctness; it is just a debugging tool.
Re-defining it to nothing avoids warnings from the solaris sunpro
compiler.  If you see warnings on your system, figure out how to force
your compiler to keep quiet, and send me a patch! */
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef __cplusplus
}
#endif

struct PerlExCxxToken {};

static void cxx_jump()
{ throw PerlExCxxToken(); }

static void
cxx_tryblock(TRYVTBL *vtbl, void *locals, void *ret)
{
    JMPENV je;
    JMPENV_INIT(je, cxx_jump);
 RESTART:
    JMPENV_TRY(je);
    try {
      switch (JMPENV_RET(je)) {
      case JMP_NORMAL:
	if (vtbl->try_normal[0])
	  (*vtbl->try_normal[0])(locals,ret);
	break;
      case JMP_EXCEPTION:
	if (vtbl->try_exception[0])
	    (*vtbl->try_exception[0])(locals,ret);
	break;
      case JMP_MYEXIT:
	if (vtbl->try_myexit[0])
	  (*vtbl->try_myexit[0])(locals,ret);
	break;
      default: 
	fprintf(stderr, "tryblock ABNORMAL\n");
	exit(1);
      }
    } catch (...) { 
      assert(JMPENV_RET(je) != JMP_NORMAL);
      goto RESTART; 
    }
    JMPENV_POP(je);
    switch (JMPENV_RET(je)) {
    case JMP_NORMAL:
      if (vtbl->try_normal[1])
	(*vtbl->try_normal[1])(locals,ret);
      break;
    case JMP_EXCEPTION:
      if (vtbl->try_exception[1])
	(*vtbl->try_exception[1])(locals,ret);
      break;
    case JMP_MYEXIT:
      if (vtbl->try_myexit[1])
	(*vtbl->try_myexit[1])(locals,ret);
      break;
    }
}

MODULE = ExtUtils::ExCxx	PACKAGE = ExtUtils::ExCxx

PROTOTYPES: ENABLE

BOOT:
  Perl_set_tryblock_method(cxx_tryblock);

void
set_tryblock(type)
	SV *type
	CODE:
	if (strEQ(SvPV(type,na), "cxx"))
	  Perl_set_tryblock_method(cxx_tryblock);
	else if (!SvTRUEx(type))
	  Perl_set_tryblock_method(0);
	else
	  croak("set_tryblock(%s): unknown", SvPV(type,na));

void
nest(cv)
	SV *cv
	CODE:
	PUSHMARK(sp);
	perl_call_sv(cv, G_NOARGS);
