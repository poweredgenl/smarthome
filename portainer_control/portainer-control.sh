#!/usr/bin/env bash
P_USER=${P_USER:-"USER"}
P_PASS=${P_PASS:-"PASS"}
P_URL=${P_URL:-"http://URL:PORT"}
P_PRUNE=${P_PRUNE:-"false"}

if [ -z ${1+x} ]; then
  echo "Parameter #1 missing: stack name "
  exit 1
fi
TARGET="$1"

if [ -z ${2+x} ]; then
  echo "Parameter #2 missing: control action. Choose START or STOP"
  exit
fi
TARGET_ACTION="$2"

echo "Updating $TARGET"

echo "Logging in..."
P_TOKEN=$(curl -s -X POST -H "Content-Type: application/json;charset=UTF-8" -d "{\"username\":\"$P_USER\",\"password\":\"$P_PASS\"}" "$P_URL/api/auth")
if [[ $P_TOKEN = *"jwt"* ]]; then
  echo " ... success"
else
  echo "Result: failed to login"
  exit 1
fi
T=$(echo $P_TOKEN | awk -F '"' '{print $4}')
echo "Token: $T"

INFO=$(curl -s -H "Authorization: Bearer $T" "$P_URL/api/endpoints/1/docker/info")
CID=$(echo "$INFO" | awk -F '"Cluster":{"ID":"' '{print $2}' | awk -F '"' '{print $1}')
echo "Cluster ID: $CID"

echo "Getting stacks..."
STACKS=$(curl -s -H "Authorization: Bearer $T" "$P_URL/api/stacks")

#echo "/---" && echo $STACKS && echo "\\---"

found=0
stack=$(echo "$STACKS"|jq --arg TARGET "$TARGET" -jc '.[]| select(.Name == $TARGET)')

if [ -z "$stack" ];then
  echo "Result: Stack not found."
  exit 1
fi
sid="$(echo "$stack" |jq -j ".Id")"
name=$(echo "$stack" |jq -j ".Name")

found=1
echo "Identified stack: $sid / $name"

existing_env_json="$(echo -n "$stack"|jq ".Env" -jc)"


echo "Executing stack..."
UPDATE=$(curl -s "$P_URL/api/stacks/$sid/$TARGET_ACTION" -X POST -H "Authorization: Bearer $T")

echo "Got response: $UPDATE"
if [ -z ${UPDATE+x} ]; then
  echo "Result: failure to update"
  exit 1
else
  echo "Result: successfully updated"
  exit 0
fi


if [ "$found" == "1" ]; then
  echo "Result: found stack but failed to process"
  exit 1
else
  echo "Result: fail"
  exit 1
fi
