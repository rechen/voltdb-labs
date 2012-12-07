#!/usr/bin/env bash

APPNAME="games"
VOLTPATH=`cd ~/voltdb-* && pwd`
CLASSPATH="`ls -1 $VOLTPATH/voltdb/voltdb-*.jar`:`ls -1 $VOLTPATH/lib/*.jar | tr '\n' ':'`"
if [ -d lib ]; then
  CLASSPATH="$CLASSPATH:`ls -1 lib/*.jar | tr '\n' ':'`"
fi
VOLTDB="$VOLTPATH/bin/voltdb"
VOLTCOMPILER="$VOLTPATH/bin/voltcompiler"
LOG4J="$VOLTPATH/voltdb/log4j.xml"
LICENSE="$VOLTPATH/voltdb/license.xml"
LEADER="localhost"

# remove build artifacts
function clean() {
    rm -rf obj debugoutput $APPNAME.jar voltdbroot log plannerlog.txt
}

# compile the source code for procedures and the client
function srccompile() {
    SRC=`find src | grep .java`
    mkdir -p obj
    javac -classpath $CLASSPATH -d obj $SRC
    # stop if compilation fails
    if [ $? != 0 ]; then exit; fi
}

# build an application catalog
function catalog() {
    srccompile
    $VOLTCOMPILER obj project.xml $APPNAME.jar
    # stop if compilation fails
    if [ $? != 0 ]; then exit; fi
}

# run the voltdb server locally
function server() {
    # if a catalog doesn't exist, build one
    if [ ! -f $APPNAME.jar ]; then catalog; fi
    # run the server
    $VOLTDB create catalog $APPNAME.jar deployment deployment.xml \
        license $LICENSE leader $LEADER
}

# run the voltdb server locally
function durable-server() {
    # if a catalog doesn't exist, build one
    if [ ! -f $APPNAME.jar ]; then catalog; fi
    # run the server
    $VOLTDB start catalog $APPNAME.jar deployment durable-deployment.xml \
        license $LICENSE leader $LEADER
}

function csv-snapshot() {
    snapshot_name="backup"
    snapshot_dir="csv-snapshot"
    curr_dir=`pwd`
    new_dir=${curr_dir}/${snapshot_name}
    mkdir -p $new_dir
    echo "Taking a snapshot named ${snapshot_name}.  Will be written to ${new_dir}"
    echo "exec @SnapshotSave '{uripath:\"file://${new_dir}\",nonce:\"${snapshot_name}\",block:true,format:\"csv\"}'" | $VOLTPATH/bin/sqlcmd
}

function help() {
    echo "Usage: ./run.sh {clean|catalog|server|help}"
}

# Run the target passed as the first arg on the command line
# If no first arg, run server
if [ $# -gt 1 ]; then help; exit; fi
if [ $# = 1 ]; then $1; else server; fi