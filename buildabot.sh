#! /usr/bin/bash

IFS=$'\n'

if ! command -v jq &> /dev/null; then
    if [ ! -f "./jq" ]; then
	wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64;
	chmod +x ./jq
    fi
    jq="./jq"
else
    jq="jq"
fi

for category in $(cat selection.json | $jq -r 'keys_unsorted[]'); do
    isdone=$(cat selection.json | $jq -r ".\"$category\".single")

    if [[ $isdone != true ]]; then
	doneprompt="Done Selecting"
    fi
    while : ; do
	echo
	echo Select $category
	select choice in $(cat selection.json | $jq -r ".\"$category\".choice | keys_unsorted[]") $doneprompt; do
	    [ $choice ] || continue
	    if [[ $choice == "Done Selecting" ]]; then
		isdone=true
	    else
		owner=$(cat selection.json | $jq -r ".\"$category\".choice.\"$choice\".owner")
		name=$(cat selection.json | $jq -r ".\"$category\".choice.\"$choice\".name")
	        select branch in $(wget -O - https://api.github.com/repos/$owner/$name/branches | $jq -r ".[].name"); do
		    [ $branch ] || continue
		    break;
		done
	        git submodule add -b $branch --name $name -- https://github.com/$owner/$name.git lib/$name
	    fi
	    break
	done
    
	$isdone && break
    done

    echo
    echo
done

git submodule update --init --recursive

