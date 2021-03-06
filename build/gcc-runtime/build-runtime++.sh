#!/usr/bin/bash
#
# {{{ CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END }}}
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2017 OmniOS Community Edition (OmniOSce) Association.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PKG=system/library/g++-runtime
PROG=libstdc++
VER=7
VERHUMAN=$VER
SUMMARY="g++ runtime dependencies libstc++/libssp"
DESC="$SUMMARY"

OPT=/opt/gcc-$VER

init
prep_build

mkdir -p $DESTDIR/usr/lib
mkdir -p $DESTDIR/usr/lib/amd64

##################################################################
LIB=libstdc++.so
LIBVER=6.0.24
XFORM_ARGS+=" -DSTDCVER=$LIBVER"

# Copy in legacy library versions

for v in 6.0.13 6.0.16 6.0.17 6.0.18 6.0.21 6.0.22; do
	if [ -f /usr/lib/$LIB.$v ]; then
		cp /usr/lib/$LIB.$v $DESTDIR/usr/lib/$LIB.$v
	else
		logerr "/usr/lib/$LIB.$v not found"
	fi

	if [ -f /usr/lib/amd64/$LIB.$v ]; then
		cp /usr/lib/amd64/$LIB.$v $DESTDIR/usr/lib/amd64/$LIB.$v
	else
		logerr "/usr/lib/amd64/$LIB.$v not found"
	fi
done

# and current version
cp $OPT/lib/$LIB.$LIBVER $DESTDIR/usr/lib/$LIB.$LIBVER \
    || logerr "Failed to copy $LIBVER"
cp $OPT/lib/amd64/$LIB.$LIBVER $DESTDIR/usr/lib/amd64/$LIB.$LIBVER \
    || logerr "Failed to copy $LIBVER (amd64)"

##################################################################
LIB=libssp.so
LIBVER=0.0.0
cp $OPT/lib/$LIB.$LIBVER $DESTDIR/usr/lib/$LIB.$LIBVER
cp $OPT/lib/amd64/$LIB.$LIBVER $DESTDIR/usr/lib/amd64/$LIB.$LIBVER

make_package runtime++.mog
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
