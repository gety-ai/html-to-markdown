#!/bin/bash

unset RUBYOPT
unset BUNDLE_GEMFILE
unset BUNDLE_APP_CONFIG
unset BUNDLE_BIN_PATH
unset BUNDLER_SETUP

exec rake compile "$@"
