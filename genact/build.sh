#!/usr/bin/env bash
BUILD_DIR=`mktemp --tmpdir --directory genact-build-debian.XXXX`
BUILD_VER="0.6.0"
CURRENT_DIR=`pwd`

mkdir -p $BUILD_DIR/{DEBIAN/,usr/bin/}

touch $BUILD_DIR/DEBIAN/control

cat <<EOF >>$BUILD_DIR/DEBIAN/control
Package: genact
Architecture: all
Maintainer: Sven-Hendrik Haase <svenstaro@gmail.com>
Priority: optional
Version: $BUILD_VER-1~cookrecipe
Description: a nonsense activity generator 
EOF

curl -s https://api.github.com/repos/svenstaro/genact/releases/latest | grep "browser_download_url.*-linux" | cut -d '"' -f 4 | wget -qi -
cp genact-linux $BUILD_DIR/usr/bin/genact
rm genact-linux

cd $BUILD_DIR
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums

find $BUILD_DIR -type d -exec chmod 0755 {} \;
find $BUILD_DIR/usr/ -type f -exec chmod 0555 {} \;

[ -d $CURRENT_DIR/target ] || mkdir $CURRENT_DIR/target
cd $CURRENT_DIR/target/

dpkg -b $BUILD_DIR/ genact-${BUILD_VER}.deb

rm -rf $BUILD_DIR
cd $CURRENT_DIR
