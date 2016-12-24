#!/bin/bash

#
# author: Robert Grubba
# contact: rgrubba@gmail.com
# version: 0.1 Alpha
#


#do not delete unless special parameter is passed to the script
DELETE=0

function usage {
    echo "for more information about usage check out README.md file"
    echo ""
    echo "./run.sh"
    echo "   -t= --type= [ zip | dir ]"
    echo "   -n= --newpackage="
    echo "   -o= --oldpackage="
    echo "   -d --delete"
    echo ""
}
function parse_args {
for i in "$@"
do
  case $i in
        -t=*|--type=*)
       		TYPE="${i#*=}"
       		shift # past argument=value
        ;;
        -o=*|--old=*)
      		OLDPACKAGE="${i#*=}"
        	shift # past argument=value
        ;;
        -n=*|--new=*)
        	NEWPACKAGE="${i#*=}"
        	shift # past argument=value
	;;
	-d|--delete)
		DELETE=1
        ;;
        -h)
        	usage 
        ;;
  esac
done
}

function check_type {
	INFO=`file $1`
	echo "$INFO" | grep "Zip archive data" > /dev/null
	if [ "$?" -eq "0" ]; then FILE_TYPE="ZIP"; fi
	echo "$INFO" | grep "bzip2 compressed data" > /dev/null
	if [ "$?" -eq "0" ]; then FILE_TYPE="BZIP2"; fi
	echo "$INFO" | grep "gzip compressed data" > /dev/null
	if [ "$?" -eq "0" ]; then FILE_TYPE="GZIP"; fi
	echo "$INFO" | grep "POSIX tar archive" > /dev/null
	if [ "$?" -eq "0" ]; then FILE_TYPE="TAR"; fi
	echo "$INFO" | grep "directory" > /dev/null
	if [ "$?" -eq "0" ]; then FILE_TYPE="DIR"; fi
	echo "filetype: $FILE_TYPE"
}

function prepare {
#mostly extract
	case "$FILE_TYPE" in
		ZIP )
			mkdir "tmp.$FILENAME"
			cd "tmp.$FILENAME"
			echo "extracting ZIP to tmp.$FILENAME"
			unzip -o ../$1 > /dev/null
			cd ..
			;;
		DIR )
			echo "linking to directory"
			ln -s "$1" "tmp.$FILENAME"
			;;
		BZIP2 )
			mkdir "tmp.$FILENAME"
			cd "tmp.$FILENAME"
			echo "extracting BZIP2 archive to tmp.$FILENAME"
			tar xfj ../$1 > /dev/null
			cd ..
			;;
		GZIP )
			mkdir "tmp.$FILENAME"
			cd "tmp.$FILENAME"
			echo "extracting GZIP archive to tmp.$FILENAME"
			tar xfz ../$1 > /dev/null
			cd ..
			;;
		TAR )
			mkdir "tmp.$FILENAME"
			cd "tmp.$FILENAME"
			echo "extracting TAR archive to tmp.$FILENAME"
			tar xf ../$1 > /dev/null
			cd ..
			;;
		*)
		;;
	esac
}

function list_files {
# arg 1 - name of source
# arg 2 - name of output file
	FILENAME=`echo $1 | rev | cut -d'/' -f1 |rev`
	check_type $1
	prepare $1
	echo "calculating sha1sums"
	cd "tmp.$FILENAME"
	find ./* -type f -exec sha1sum {} \; > ../$2
	cd ..
	rm -rf "tmp.$FILENAME"
}

function find_new_files {
# args 1 - new list 
# args 2 - old list
# args 3 - output
echo "looking for new files"
	OLDFILE=0
	NEWFILE=0
	> $3
	while read -r SHA1 LOCATION
	do
		egrep "$SHA1.*$LOCATION" $1 > /dev/null
		if [ "$?" == "0" ]
		then
			((OLDFILE++))
		else  
			((NEWFILE++))
			echo "$LOCATION" >> $3
		fi
	done < $2
			
	echo "existing files: $OLDFILE"
	echo "new files: $NEWFILE"
}

function create_package {
	# 1 - new package name
	# 2 - file list name 
	mkdir dyfer
	cd dyfer
	echo "extracting files"
	unzip -o ../$1 > /dev/null
	echo "creating dyfer package"
	tar cfj ../dyfer."$1".tar.bz2 -T ../$2
	cd ..
	rm -rf dyfer
}

parse_args $*
list_files "$OLDPACKAGE" old.sums & 
list_files "$NEWPACKAGE" new.sums &
wait
find_new_files "old.sums" "new.sums" "new.files"

create_package "$NEWPACKAGE" "new.files"


