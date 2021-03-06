Apache Log Simulator
========================

This sample application demonstrates how to write an application that can read
and store apache log file information. The tables are organized to partition the
data based on an interval, a 15 minute period, that can be easily queried to see
how often an asset file is called, its size and the bandwidth utilization. This
can be done on a single asset or against all assets. The application will display 
apache bandwidth statistics and VoltDB throughput statistics.

VoltDB Requirements
===================
Sample requires VoltDB 2.8.4 or higher.
Maven 2


Setup
=====
Running the application requires either two or three consoles depending on how
deep you want to go.

Building
========
You must first have the VoltDB Client and Procedure libraries installed into the
maven local repository. Go into the <voltdb_home>/voltdb directory and run:

    mvn install:install-file -Dfile=./voltdb-2.8.4.1.jar -DgroupId=org.voltdb \
    -DartifactId=VoltDB -Dversion=2.8.4.1 -Dpackaging=jar

    mvn install:install-file -Dfile=./voltdbclient-2.8.4.1.jar -DgroupId=org.voltdb \
    -DartifactId=VoltDBClient -Dversion=2.8.4.1 -Dpackaging=jar

Building the application from the sample's root directory by running:

    mvn clean install package

Running
=======
Open two console windows. In both, execute:

    export VOLT_HOME=<volt_home_directory>

To run the server:

    cd ./procedures
    ./run.sh

To run the client:

    cd ./client
    ./run.sh

The application will run for two minutes, populating the database with bandwidth
data.

You can alter the command line for the client to point to a cluster or change
the runtime. The application takes the following command line parameters:
    --displayinterval <arg>   How often to display transaction statistics.
    --password <arg>          Volt password
    --runtime <arg>           Runtime in seconds.
    --servers <arg>           Comma separated list volt servers to conenct
                              to. server[:port]
    --user <arg>              Volt user name
