#!/usr/bin/env bash
BUILD_DIR=`mktemp --tmpdir --directory genact-build-debian.XXXX`
BUILD_VER="0.0.1"
CURRENT_DIR=`pwd`

mkdir -p $BUILD_DIR/DEBIAN/

touch $BUILD_DIR/DEBIAN/control

cat <<EOF >>$BUILD_DIR/DEBIAN/control
Package: genact
Architecture: all
Maintainer: Patrick Wu <wotingwu@live.com>
Depends: xclip, gnome-themes-standard, gtk2-engines-murrine, dbus, dbus-x11, fonts-noto-cjk, fonts-noto-cjk-extras, fonts-noto-color-emoji, lxappearance, adwaita-icon-theme-full
Priority: optional
Version: $BUILD_VER-1
Description: Patrick's Quick Installation Virtual Package - GUI Quick Installation
EOF

cd $BUILD_DIR
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums

find $BUILD_DIR -type d -exec chmod 0755 {} \;

[ -d $CURRENT_DIR/target ] || mkdir $CURRENT_DIR/target
cd $CURRENT_DIR/target/

dpkg -b $BUILD_DIR/ genact-${BUILD_VER}.deb

rm -rf $BUILD_DIR
cd $CURRENT_DIR
