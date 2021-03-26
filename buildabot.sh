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
	        select branch in $(wget -O - https://api.github.com/repos/$owner/$name/branches | $jq -r ".[].name"); do
		    [ $branch ] || continue
		    break;
		done
	        git submodule add -b $branch --name $name -- https://github.com/$owner/$name.git lib/$name

		include=$(cat selection.json | $jq -r ".\"$category\".choice.\"$choice\".include")
		class=$(cat selection.json | $jq -r ".\"$category\".choice.\"$choice\".class")

		[[ $class == "null" ]] && class=""
		
		for i in include.hh extern.cc; do
		    sed -i "s|BUILDABOT_INCLUDE|#include <${include}>\\${nl}BUILDABOT_INCLUDE|g" $i
		    [[ $class ]] \
			&& sed -i "s|BUILDABOT_TEMPLATE_BEGIN|BUILDABOT_TEMPLATE_BEGIN${class}<|g" $i \
			&& sed -i "s|BUILDABOT_TEMPLATE_END|>BUILDABOT_TEMPLATE_END|g" $i
		done
		sed -i "s|BUILDABOT_SUBDIR|add_subdirectory(lib/${name})\\${nl}BUILDABOT_SUBDIR|g" CMakeLists.txt
		[[ $name == "discordpp" ]] \
		    && sed -i "s|BUILDABOT_TLL|discordpp\\${nl}        BUILDABOT_TLL|g" CMakeLists.txt \
		    || sed -i "s|BUILDABOT_TLL|discordpp-$name\\${nl}        BUILDABOT_TLL|g" CMakeLists.txt
	    fi
	    break
	done
    
	$isdone && break
    done

    echo
    echo
done

for i in include.hh extern.cc; do
    sed -i "/BUILDABOT_INCLUDE/d" $i
    sed -i "s/BUILDABOT_TEMPLATE_BEGIN//g" $i
    sed -i "s/BUILDABOT_TEMPLATE_END//g" $i
done
sed -i "/BUILDABOT_SUBDIR/d" CMakeLists.txt
sed -i "/BUILDABOT_TLL/d" CMakeLists.txt

git submodule update --init --recursive

rm selection.json
rm buildabot.sh
if [ -f "./jq" ]; then
    rm ./jq
fi

git commit -a -m "Customized Template" --author "Build-A-Bot <>"

popd
