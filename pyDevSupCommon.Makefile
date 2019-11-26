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
# Date    : Tuesday, November 26 11:17:24 CET 2019
# version : 0.0.2
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

#USR_CPPFLAGS += -DUSE_TYPED_RSET

USR_CPPFLAGS += -DXEPICS_ARCH=\"$(T_A)\"
USR_CPPFLAGS += -DXPYDEV_BASE=\"$(pyDevSupCommon_DIR)\"
USR_CPPFLAGS += -DXEPICS_BASE=\"$(EPICS_BASE)\"
USR_CPPFLAGS += -DPYDIR=\"$(PYTHON)\"
USR_CPPFLAGS += -DHAVE_NUMPY

USR_CPPFLAGS += $(shell python-config --cflags)
USR_LDFLAGS  += $(shell python-config --ldflags)


HEADERS += $(APPSRC)/pydevsup.h


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

DBDS += $(COMMON_DIR)/pyDevSup.dbd


SCRIPTS += $(wildcard ../iocsh/*.iocsh)

# Fake the dbd file in order to trigger the generation of registerRecordDeviceDriver.cpp
# Not yet sure, it will do correctly
# Tuesday, November 26 11:17:04 CET 2019, jhlee
utest$(DEP):
	@rm -rf $(COMMON_DIR)/pyDevSup.dbd
	@touch $(COMMON_DIR)/pyDevSup.dbd


## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

db: 

.PHONY: db 


vlibs:

.PHONY: vlibs
