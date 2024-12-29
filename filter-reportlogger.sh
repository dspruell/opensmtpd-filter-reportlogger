#!/bin/ksh
#
# OpenSMTPD filter (smtpd-filters(7)) to log reporting information.

set -e -u

set -A REGISTER_LINES -- \
        "register|report|smtp-in|link-connect" \
        "register|report|smtp-in|link-identify" \
        "register|report|smtp-in|link-disconnect" \
        "register|report|smtp-in|link-auth" \
        "register|report|smtp-in|timeout" \
        "register|ready"

PROGNAME="$(basename "$0")"

# Output log message to stdout (resulting in logging via smtpd(8)).
#
# MSG: message to log.
#
emit_log()
{
	MSG="$1"
	echo "info: $MSG" >&2
}


# Process input event stream and write to specified output file.
# 
# OUTFILE: writable output file.
#
process_stream_to_output()
{
	OUTFILE="$1"
	emit_log "writing events from stdin to $OUTFILE"
	while read -r line
	do
        	echo "$line" >> "$OUTFILE"
        	emit_log "received line >>$line<<"
        	if echo "$line" | grep -F -q "config|ready"
        	then
            		emit_log "configuration received from smtpd (ready to process events)"
			for out_line in "${REGISTER_LINES[@]}"
			do
                		echo "$out_line"
                		emit_log "wrote the ${out_line} line to smtpd on stdout"
			done
		fi
	done
}

OUTFILE="$(mktemp -t "${PROGNAME%.*}-XXXXXXXX")"
process_stream_to_output "$OUTFILE"
