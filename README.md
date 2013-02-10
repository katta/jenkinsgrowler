Want a notification on your desktop when a jenkins job completes ? 

This does that exactly, at regular intervals it checks if any of the configured jobs had run and if so it figures the status and change set and notifies via growl.

## Build Status

[![Build Status](https://travis-ci.org/katta/jenkinsgrowler.png?branch=master)](https://travis-ci.org/katta/jenkinsgrowler)

## Installation

### Prerequisites

Growl notifier command line tool has to be installed and should be available on PATH.

### Installing from rubygems

```bash
$ gem install jenkinsgrowler
```

### Building from source

```bash
$ git clone https://github.com/katta/jenkinsgrowler.git
$ cd jenkinsgrowler
$ rake
$ gem install pkg/jenkinsgrowler.gem
```

# Running

```bash
Usage: jenkinsgrowler [options]
    -s, --server SERVER_URL          URL of the jenkins server
    -j, --jobs JOBS                  Comma separated jobs names
    -i, --interval INTEVAL           Polling interval in seconds. Default (60 seconds)
    -u, --user USERNAME              Username for basic authentication
    -p, --password PASSWORD          Password for basic authentication
    -t, --timezone TIMEZONE          Servers timeone. Default (+0530)
    -h, --help                       Displays help message
```

## Examples

### Provide server url and job names to be monitored

```bash
$ jenkinsgrowler -s "http://old-ci.motechproject.org/" -j "GrowlerTest"
```

In the above example the `http://ci.myhost.com/` is the jenkins continuous integration server url and `GrowlerTest` is a job name ot be monitored.

You can also monitor more than one job by specifying comma spearate job names like 

```bash
$ jenkinsgrowler -s "http://old-ci.motechproject.org/" -j "GrowlerTest, Job3"
```

### Basic authentication

If your ci server is protected with basic authentication, you could just pass on the credentials to the `jenkinsgrowler` as shown below

```bash
$ jenkinsgrowler -s "http://old-ci.motechproject.org/" -j "GrowlerTest" -u "username" -p "password"
```
