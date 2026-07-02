#! /bin/bash

ARCH=x86_64
APP=minesweeper_game
APPNAME=Minesweeper
BUNDLE=build/linux/x64/release/bundle

flutter clean
flutter pub cache repair
flutter pub get
flutter build linux --release

rm -r AppDir/
mkdir -p AppDir/usr/bin

cp "$BUNDLE/$APP" AppDir/usr/bin/
cp -r "$BUNDLE/lib"  AppDir/usr/bin/lib
cp -r "$BUNDLE/data" AppDir/usr/bin/data
cp "$APP.png" "AppDir/$APP.png"

cat > AppDir/AppRun << 'EOF'
#!/bin/bash
exec "$APPDIR/usr/bin/minesweeper_game" "$@"
EOF
chmod +x AppDir/AppRun

cat > AppDir/$APP.desktop << EOF
[Desktop Entry]
Type=Application
Name=$APPNAME
Exec=$APP
Icon=$APP
Categories=Utility;Game;
EOF

./appimagetool-x86_64.AppImage AppDir "$APPNAME-$ARCH.AppImage"
chmod +x "$APPNAME-$ARCH.AppImage"