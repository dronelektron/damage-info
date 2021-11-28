#!/bin/bash

PLUGIN_NAME="damage-info"

cd scripting
spcomp $PLUGIN_NAME.sp -o ../plugins/$PLUGIN_NAME.smx
