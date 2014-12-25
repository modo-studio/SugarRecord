#!/bin/bash

# Installing xctool
brew install xctool

# Executing tests on the tests project
cd project
pod install
xctool test -workspace project.xcworkspace -scheme project -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO

# Building example project
cd ..
cd example
pod install
xctool build -workspace SugarRecordExample.xcworkspace -scheme SugarRecordExample -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
