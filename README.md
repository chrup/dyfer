# dyfer

dyfer is a simple bash script created with the idea of reducing size of deployment packages that needs to be sent through slow networks, good for artifacts that consists from large number of files, and not all are changed with the next deployment. Script compares two packages/directories, finds differences and creates package consisting only from changed files.

** It is not finished yet, thus you may use it only on your own risk **
## TODO list
- [x] create basic functionality of creating raw package from zipped artifacts
- [x] prepare simple input recognizing mechanisms
- [ ] allow users to set type of output compression
- [ ] create deployment script
- [ ] implement verification of input (for user errors)
- [ ] perform extended  tests
- [ ] create documentation

## Usage

./run.sh
   -t= --type= [ zip | dir ] 
   -n= --newpackage=
   -o= --oldpackage=
   -d --delete

## Contact
You can mail me rgrubba <at> gmail <dot> com or reach through linkedin.

