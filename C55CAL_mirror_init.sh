#!/bin/bash

find ./meta-byosoft -name local.conf.sample | xargs -I {} sed -i 's|^#DL_DIR.*|DL_DIR ?= "${HOME}/5XCAL_DL"|' {}
find ./meta-byosoft -name local.conf.sample | xargs -I {} sed -i 's|^SOURCE_MIRROR_URL.*|SOURCE_MIRROR_URL = "http://192.168.11.8/oe-mirror/5XCAL"|' {}
