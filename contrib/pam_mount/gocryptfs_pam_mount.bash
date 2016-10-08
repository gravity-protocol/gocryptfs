#!/bin/bash
#
# Simple bash script to transform the command-line arguments that
# pam_mount passes to gocryptfs into something that gocryptfs
# understands.
#
# Currently understood: nonempty,allow_other,quiet.
# Unknown options are ignored.

exec >&2
set -eu

if [[ $# != 4 ]]; then
	MYNAME=$(basename $0)
	echo "$MYNAME: expected 4 arguments, got $#"
	echo "Example: $MYNAME /home/user.crypt /home/user.plain -o allow_other"
	echo "Example: $MYNAME /home/user.crypt /home/user.plain -o defaults"
	exit 1
fi

SRC=$1
DST=$2
GOPTS=""
for OPT in nonempty allow_other quiet; do
	if [[ $4 == *$OPT* ]]; then
		GOPTS="$GOPTS -$OPT"
	fi
done

cd "$(dirname "$0")"
exec ./gocryptfs $GOPTS $SRC $DST
