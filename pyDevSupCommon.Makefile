#
#  Copyright (c) 2019    European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : saeedhaghtalab
# email   : saeedhaghtalab@esss.se
#           jeonghan.lee@esss.se
#          
# Date    : Monday, November 25 22:58:57 CET 2019
# version : 0.0.1
#
## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS



# If one would like to use the module dependency restrictly,
# one should look at other modules makefile to add more
# In most case, one should ignore the following lines:

ifneq ($(strip $(PYTHON_DEP_VERSION)),)
PYTHON:=python$(PYTHON_DEP_VERSION)
else
PYTHON:=python3
endif


## Exclude linux-ppc64e6500
EXCLUDE_ARCHS += linux-ppc64e6500
EXCLUDE_ARCHS += linux-corei7-poky

APP:=devsupApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src
DEVSUP:=$(APPSRC)/devsup


USR_INCLUDES += -I$(where_am_I)$(APPSRC)

USR_CPPFLAGS += -DUSE_TYPED_RSET

USR_CPPFLAGS += -DXEPICS_ARCH=\"$(T_A)\"
USR_CPPFLAGS += -DXPYDEV_BASE=\"$(E3_MODULES_INSTALL_LOCATION)\"
USR_CPPFLAGS += -DXEPICS_BASE=\"$(EPICS_BASE)\"
#USR_CPPFLAGS += -DPYDIR=\"$(PYTHON)\"
USR_CPPFLAGS += -DHAVE_NUMPY

USR_CPPFLAGS += $(shell python-config --cflags)
USR_LDFLAGS  += $(shell python-config --ldflags)



SOURCES += $(APPSRC)/dbapi.c
SOURCES += $(APPSRC)/dbdset.c
SOURCES += $(APPSRC)/dbfield.c
SOURCES += $(APPSRC)/dbrec.c
SOURCES += $(APPSRC)/utest.c

SCRIPTS += $(DEVSUP)/__init__.py
SCRIPTS += $(DEVSUP)/db.py
SCRIPTS += $(DEVSUP)/dset.py
SCRIPTS += $(DEVSUP)/hooks.py
SCRIPTS += $(DEVSUP)/interfaces.py
SCRIPTS += $(DEVSUP)/util.py
SCRIPTS += $(DEVSUP)/disect.py
SCRIPTS += $(DEVSUP)/ptable.py

# We have no way to keep the same file name in the $(pyDevSup_DIR)
# So, remove test here. Anyway, test is not necessary to keep them
# in the production
# Monday, November 25 23:44:15 CET 2019, jhlee

#SCRIPTS += $(DEVSUP)/test/__init__.py
#SCRIPTS += $(DEVSUP)/test/util.py
#SCRIPTS += $(DEVSUP)/test/test_db.py


SCRIPTS += $(wildcard ../iocsh/*.iocsh)


## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

db: 

.PHONY: db 

#
# USR_DBFLAGS += -I . -I ..
# USR_DBFLAGS += -I $(EPICS_BASE)/db
# USR_DBFLAGS += -I $(APPDB)
#
# SUBS=$(wildcard $(APPDB)/*.substitutions)
# TMPS=$(wildcard $(APPDB)/*.template)
#
# db: $(SUBS) $(TMPS)

# $(SUBS):
#	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
#	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
#	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
#	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

# $(TMPS):
#	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
#	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
#	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
#	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@

#
# .PHONY: db $(SUBS) $(TMPS)

vlibs:

.PHONY: vlibs

# vlibs: $(VENDOR_LIBS)

# $(VENDOR_LIBS):
# 	$(QUIET)$(SUDO) install -m 755 -d $(E3_MODULES_VENDOR_LIBS_LOCATION)/
# 	$(QUIET)$(SUDO) install -m 755 $@ $(E3_MODULES_VENDOR_LIBS_LOCATION)/

# .PHONY: $(VENDOR_LIBS) vlibs



