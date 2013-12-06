# Knife Reporting

A knife plugin for use with OpsCode Chef's reporting system.

## Commands
There are two basic commands `knife runs list` and `knife runs show`

`knife runs list` returns a listing of node runs by org or by node. To get a
listing by org just use the basic command. To get a listing by node pass the
optional node name parameter.

* `knife runs list` - returns a list of all runs within the organization
* `knife runs list bobsnode` - return a list of all runs on "bobsnode"

These commands default to returning the last 24 hours worth of data.

If more than 24 hours worth of data is desired, or if a different time frame
is desired, the --startime or -s option and --endtime or -e option can be given.
They specify a starting and ending time to returns runs from. They take an
argument in the date form of MM-DD-YYYY. If one of these options is specified
the other must also be specified.

The start and end time can be specified as a unix timestamp if the
--unixtimestamps or -u option is also specified.

Note that no more than three months worth of data can be requested at a time.
If more than three months of data is asked for an error will be returned.

User can also specify the number of rows that should be returned with
the result. This parameter is optional and defaults to 10.

`knife runs show` has one  parameter run id. It will return that specific run details.

* `knife runs show bobsnode 30077269-59d0-4283-81f6-8d23cbed3a7a` - returns details
about that specific node run
