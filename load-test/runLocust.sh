#!/bin/sh
#
# Run locust load test
#
#####################################################################
ARGS="$@"
HOST="${1}"
SCRIPT_NAME=`basename "$0"`

do_usage() {
    cat >&2 <<EOF
Usage:
  ${SCRIPT_NAME} [ host ] OPTIONS
Description:
  Runs load test against specified host
EOF
  exit 1
}

while getopts ":h:c:r:" o; do
  case "${o}" in
    h)
        TARGET_HOST=${OPTARG}
        echo $TARGET_HOST
        ;;
    c)
        C=${OPTARG:=2}
        echo $c
        ;;
    r)
        R=${OPTARG:=10}
        echo $r
        ;;
    *)
        do_usage
        ;;
  esac
done


# if [ $# -eq 0 ]; then
#   if [ -n "${TARGET_HOST:+1}" ]; then
# 	HOST=$TARGET_HOST
#   else
# 	do_usage
#   fi
# fi

if [ -n "${LOCUST_FILE:+1}" ]; then
	echo "Locust file: " $LOCUST_FILE
else
	LOCUST_FILE="locustfile.py" 
	echo "Default Locust file: " $LOCUST_FILE
fi

echo "Running load test against $HOST. Spawning $C clients and $R total requets."
locust --host=http://$HOST -f $LOCUST_FILE --clients=$C --hatch-rate=1 --num-request=$R --no-web
echo "done"