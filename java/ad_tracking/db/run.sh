#!/usr/bin/env bash

. ./env.sh

APPNAME="ad_tracking"

# remove build artifacts
function clean() {
    rm -rf obj log statement-plans $APPNAME.jar voltdbroot catalog-report.html
}

# compile the source code for procedures and the client
function srccompile() {
    if ls src/procedures/*.java &> /dev/null; then
        mkdir -p obj
        javac -classpath $CLASSPATH -d obj \
            src/procedures/*.java
        # stop if compilation fails
        if [ $? != 0 ]; then exit; fi
    fi
}

# build an application catalog
function catalog() {
    srccompile
    voltdb compile --classpath obj -o $APPNAME.jar ddl.sql
    # stop if compilation fails
    if [ $? != 0 ]; then exit; fi
}

# run the voltdb server locally
function server() {
    # if a catalog doesn't exist, build one
    if [ ! -f $APPNAME.jar ]; then catalog; fi
    # run the server
    voltdb create catalog $APPNAME.jar license $LICENSE
}

function help() {
    echo "Usage: ./run.sh {srccompile|catalog|server|clean|help}"
}

# Run the target passed as the first arg on the command line
# If no first arg, run server
if [ $# -gt 1 ]; then help; exit; fi
if [ $# = 1 ]; then $1; else server; fi