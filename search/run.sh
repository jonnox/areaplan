#! /bin/bash
# Compiles and runs
gcc `gnustep-config --objc-flags` -o main main.m -L /GNUstep/System/Library/Libraries -lobjc -lgnustep-base
./main.exe