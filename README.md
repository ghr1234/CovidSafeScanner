# CovidSafeScanner
Sample code that discovers and reads the Australian government [CovidSafe app](https://apps.apple.com/au/app/covidsafe/id1509242894) peripheral

macOS and iOS targets are included.

The data emitted by the COVIDSafe app is a JSON object:

```JSON
{
	"modelP": "iPhone 8",
	"org": "AU_DTA",
	"msg": "3NzZjNcQfCGPoTaCjYfSHzVdkhy9jKp1eGqH352Y7ouVRj9V+kgiiAmlGHs8wid1TzNM6KqvHOvhmC/o+m7LDicSbfXHkWal2GGLCP9yGIHhaL+bRj0oois=",
	"v": 1
}
```
`modelP` is the device model
`org` is a constant  *AU_DTA*
`msg` is an identifier that appears to randomise every 15 minutes or so.
`v` presumably is a version - version 1.
