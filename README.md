# dyfer

dyfer is a bash script created by the need for reducing size of deployment packages, which are sent through slow network connections, it is good for artifacts that consists from large number of files, and not all are changed between deployments. Script compares two archives/packages/directories, finds differences based on file location and its sha1sum, then creates package consisting only from changed files.

**It is not finished yet, thus you may use it only on your own risk**
## TODO list
- [x] create basic functionality of creating raw package from zipped artifacts
- [x] prepare simple input recognizing mechanisms
- [ ] allow users to set type of output compression
- [ ] create deployment script
- [ ] implement verification of input (for user errors)
- [ ] perform extended  tests
- [ ] create good documentation

## Usage

./run.sh
   -t= --type= [ zip | dir ] 
   -n= --newpackage=
   -o= --oldpackage=
   -d --delete

## Licensing

You may use my script on GPL licensing rules.

## Contact
You can mail me rgrubba@gmail.com or reach through linkedin.

