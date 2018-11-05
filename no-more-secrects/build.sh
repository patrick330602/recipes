#!/usr/bin/env bash
BUILD_DIR=`mktemp --tmpdir --directory nms-build-debian.XXXX`
BUILD_NC_DIR=`mktemp --tmpdir --directory nms-nc-build-debian.XXXX`
BUILD_VER="0.3.3"
CURRENT_DIR=`pwd`

mkdir -p $BUILD_DIR/{DEBIAN/,usr/bin/,usr/share/man/man6/}

touch $BUILD_DIR/DEBIAN/control

cat <<EOF >>$BUILD_DIR/DEBIAN/control
Package: nms
Architecture: all
Maintainer: Ferdinand Thiessen <rpm@fthiessen.de>
Priority: optional
Version: $BUILD_VER-1
Conflicts: nms-ncurses
Description: A tool set to recreate the famous "decrypting text" effect as seen in the 1992 movie Sneakers.
EOF

make all

cp bin/* $BUILD_DIR/usr/bin/
cp *.6 $BUILD_DIR/usr/share/man/man6

cd $BUILD_DIR
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums

find $BUILD_DIR -type d -exec chmod 0755 {} \;
find $BUILD_DIR/usr/ -type f -exec chmod 0555 {} \;
find $BUILD_DIR/usr/share/man/man6/ -type f -exec chmod 644 {} \;

[ -d $CURRENT_DIR/target ] || mkdir $CURRENT_DIR/target
cd $CURRENT_DIR/target/

sudo dpkg -b $BUILD_DIR/ nms-${BUILD_VER}.deb

rm -rf $BUILD_DIR
cd $CURRENT_DIR

mkdir -p $BUILD_NC_DIR/{DEBIAN/,usr/bin/,usr/share/man/man6/}

touch $BUILD_NC_DIR/DEBIAN/control

cat <<EOF >>$BUILD_NC_DIR/DEBIAN/control
Package: nms-ncurses
Architecture: all
Maintainer: Ferdinand Thiessen <rpm@fthiessen.de>
Priority: optional
Version: $BUILD_VER-1
Depends: lib32ncurses5-dev
Conflicts: nms
Description: A tool set to recreate the famous "decrypting text" effect as seen in the 1992 movie Sneakers.
EOF

make all-ncurses

cp bin/* $BUILD_NC_DIR/usr/bin/
cp *.6 $BUILD_NC_DIR/usr/share/man/man6

cd $BUILD_NC_DIR
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums

find $BUILD_NC_DIR -type d -exec chmod 0755 {} \;
find $BUILD_NC_DIR/usr/ -type f -exec chmod 0555 {} \;
find $BUILD_NC_DIR/usr/share/man/man6/ -type f -exec chmod 644 {} \;

[ -d $CURRENT_DIR/target ] || mkdir $CURRENT_DIR/target
cd $CURRENT_DIR/target/

sudo dpkg -b $BUILD_NC_DIR/ nms-ncurses-${BUILD_VER}.deb

rm -rf $BUILD_NC_DIR
cd $CURRENT_DIR
