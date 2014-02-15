#! /bin/sh

clear

# ===============================================
# Validate URL

if [ ! -z "$1" ]
then
	url=$( echo "$1" | grep '^http' );
	if [ -z "$url" ]
	then	
		echo "'$1' is not a valid URL";
	else
		echo "Using '$url' as the source of the URLs";
	fi
else
	echo 'You need to supply a source URL';
fi

# ===============================================
# define output method
output='file';
if [ ! -z "$2" ]
then
	if [ "$2" = 'screen' ]
	then
		output='screen';
	fi
fi
if [ "$output" = 'screen' ]
then
	echo 'writing output to screen';
	# todo define log to screen function here
else
	echo 'writing output to log file';
	# todo define log to file function here
fi



