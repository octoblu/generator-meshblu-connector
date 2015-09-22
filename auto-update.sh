#!/bin/bash
CONNECTOR=$1
if [ -z "$1" ]; then
  echo "ERROR: Must include meshblu-connector"
  echo "Usage: ./auto-update.sh [meshblu-connector]"
  exit 1
fi

echo "* running for connector: $CONNECTOR"
cd ~/Projects/Octoblu/$CONNECTOR
COMMAND='yo meshblu-connector'
if [ -f './index.coffee' ]; then
  echo "* it is coffee"
  COMMAND="$COMMAND --coffee"
fi

echo "* Running the generator"
$COMMAND

echo "* Upgrade done."

read -p "Are you feeling dangerous and want to push? Press [enter] to continue..."
gump "upgraded connector"
