#!/bin/sh
#
# Copyright (c) 2011 - 2013 Amazon Technologies, Inc.  All rights reserved.
# PROPRIETARY/CONFIDENTIAL
# Use is subject to license terms.

if [ -f /PRE_GM_DEBUGGING_FEATURES_ENABLED__REMOVE_AT_GMC ]; then
    lipc-set-prop com.lab126.kaf logLevel perf
fi

