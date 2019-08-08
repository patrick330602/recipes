#!/usr/bin/env bash
BUILD_DIR=`mktemp --tmpdir --directory nms-build-debian.XXXX`
BUILD_VER="6.0.0"
CURRENT_DIR=`pwd`

git clone https://github.com/tj/n sources

mkdir -p $BUILD_DIR/{DEBIAN/,usr/bin/}

touch $BUILD_DIR/DEBIAN/control

cat <<EOF >>$BUILD_DIR/DEBIAN/control
Package: n
Architecture: all
Maintainer: TJ Holowaychuk <tj@vision-media.ca>
Priority: optional
Version: $BUILD_VER-0
Description: Interactively Manage All Your Node Versions
EOF

cp sources/bin/* $BUILD_DIR/usr/bin/

cd $BUILD_DIR
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums

find $BUILD_DIR -type d -exec chmod 0755 {} \;
find $BUILD_DIR/usr/ -type f -exec chmod 0555 {} \;

[ -d $CURRENT_DIR/target ] || mkdir $CURRENT_DIR/target
cd $CURRENT_DIR/target/

dpkg -b $BUILD_DIR/ n-${BUILD_VER}.deb

rm -rf $BUILD_DIR
cd $CURRENT_DIR
rm -rf sources
