# opensmtpd-filter-reportlogger

OpenSMTPD filter which logs all report output to a file.

## Setup

1. Copy `filter-reportlogger.sh` to the smtpd(8) filter directory:
    
    ```
    install -oroot -gbin -m0755 filter-reportlogger.sh /usr/local/libexec/smtpd/filter-reportlogger
    ```
3. Activate the filter in smtpd.conf(5):
    
    ```
    filter reportlogger proc-exec "filter-reportlogger"

    listen on egress filter "reportlogger"
    ```

## Overview

**opensmtpd-filter-reportlogger** is an experimental
[filter](https://man.openbsd.org/smtpd-filters.7) for
[OpenSMTPD](https://www.opensmtpd.org/) that registers to receive all
report events from smtpd(8) and logs them to an output file.

Currently:

* The filter is implemented as a (KSH) shell program.
* The filter registers to receive several events in the *smtp-in* subsystem.
* The output file may be specified as either:
    * A user-specified file path (the typical use case).
    * A temporary file (typically written under `/tmp`). This is useful for
      testing.
* Debug output is generated and logged to stdout, resulting in smtpd(8) logging
  that output in the maillog. This output is configurable and includes the
  following:
    * A startup notice, including the path to the output file.
    * Error output.
    * Debug output, including a copy of every event received by the filter, if
      debug logging is enabled.
    * A report on shutdown of the program or input termination.

## Python (WIP)

A work in progress Python implementation of the filter is also available
(`filter-reportlogger.py`). This implementation doesn't currently appear to
complete filter registration correctly and doesn't log any events to the output
file.
