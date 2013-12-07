#!/bin/sh

PREFIX=/usr/local
[ $# -ge 1 -a -d "$1"] && PREFIX="$1"

export TOPDIR=../..

(
	cd "$TOPDIR"
	touch aclocal.m4 configure Makefile.in config.h.in
	./configure --prefix="$PREFIX" --with-wx-config=wxgtk2u-2.8-config --with-boost-lib-suffix=''
	make
	strip wxmedit
	sudo make install
	DOCDIR="$PREFIX/share/doc/wxmedit"
	sudo mkdir -p "$DOCDIR"
	sudo cp ChangeLog LICENSE README.txt "$DOCDIR"
)

ver=`sed -n '3s/^.*v//;3s/://p' "$TOPDIR/ChangeLog"`
echo "$ver" | grep '-' > /dev/null
[ $? -eq 0 ] || ver="$ver"-1

pkg_create -p "$PREFIX" -c -"wxMEdit: Cross-platform Text/Hex Editor, a fork of MadEdit" -d pkg-descr -f pkg-plist "wxmedit-$ver"
