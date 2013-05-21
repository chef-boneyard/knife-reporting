# Knife Reporting

A knife plugin for use with OpsCode Chef's reporting system.

## Commands
There are two basic commands `knife runs list` and `knife runs show`

`knife runs list` returns a listing of node runs by org or by node. To get a
listing by org just use the basic command. To get a listing by node pass the
optional node name parameter.

* `knife runs list` - returns a list of all runs within the organization
* `knife runs list bobsnode` - return a list of all runs on "bobsnode"

`knife runs show` returns a detailed list of runs. It has two parameters
node name and run id. run id is optional. Calling `knife runs show` with only
a node name will return a detailed list of runs within that node. Calling
it with both node name and run id will return that specific run.

* `knife runs show bobsnode` - returns a detailed list of all runs within that node
* `knife runs show bobsnode 30077269-59d0-4283-81f6-8d23cbed3a7a` - returns details
about that specific node run
