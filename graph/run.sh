#! /bin/bash
# Compiles and runs
gcc `gnustep-config --objc-flags` -o main Graph.m Vertex.m Edge.m main.m -L /GNUstep/System/Library/Libraries -lobjc -lgnustep-base
./main.exe