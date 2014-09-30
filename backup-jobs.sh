#!/bin/sh
#
# Requires:
# - curl
# - jq (http://stedolan.github.io/jq/)
# - git (assumes we are launched from inside a Git repo)

set -e

fetch_jobs() {
    local readonly HIPP_URL="$1"

    for j in $(curl -s "$HIPP_URL/api/json" | jq '.jobs | .[] | .name' | sed -s 's/"//g'); do
        echo "Backuping job $j..."
        curl -s -n "$HIPP_URL/job/$j/config.xml" > "$j.xml"
    done
}

cd $(dirname $0)
rm -f *.xml
fetch_jobs https://hudson.eclipse.org/sirius
git add -A .
git commit -m "Automatic backup."
