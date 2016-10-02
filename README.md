# Knife Reporting

A knife plugin for use with Chef's reporting system.

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

## Contributing

For information on contributing to this project see <https://github.com/chef/chef/blob/master/CONTRIBUTING.md>

## License and Authors

```text
Copyright 2013-2016 Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```