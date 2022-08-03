#! /usr/bin/bash

pushd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

IFS=$'\n'
nl=$'\n'

echo "Enter a project name: "
read project

for i in CMakeLists.txt .github/workflows/main.yml Dockerfile; do
    sed -i "s/BUILDABOT_PROJECT_NAME/$project/g" $i
done

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
	        select branch in "master" $(wget -O - https://api.github.com/repos/$owner/$name/branches | $jq -r ".[].name" | sed '/^master$/d'); do
		    [ $branch ] || continue
		    break;
		done
	        git submodule add -b $branch --name $name -- https://github.com/$owner/$name.git lib/$name

		include=$(cat selection.json | $jq -r ".\"$category\".choice.\"$choice\".include")

		sed -i "s|#BUILDABOT_SUBDIR|add_subdirectory(lib/${name})\\${nl}#BUILDABOT_SUBDIR|g" CMakeLists.txt
	    fi
	    break
	done
    
	$isdone && break
    done

    echo
    echo
done

sed -i "/#BUILDABOT_SUBDIR/d" CMakeLists.txt
sed -i "/message(FATAL_ERROR \"Please run buildabot.sh\")/d" CMakeLists.txt

git submodule update --init --recursive

rm selection.json
rm buildabot.sh
if [ -f "./jq" ]; then
    rm ./jq
fi

git commit -a -m "Customized Build-A-Bot Template" --author "Build-A-Bot <>"

popd
