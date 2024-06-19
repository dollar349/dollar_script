#!/bin/bash

OPT_CFG="./OPT.cfg"
echo "" > ${OPT_CFG}
if test "${1}" = "";then
    echo "Please give a patch name !!!"
    exit 1
fi

PATCH=$(cat ${1})
NOT_SET_NAME=$(echo "${PATCH}" | grep -E '^-[^-]' | grep -v 'is not set' | sed -n 's/^-*\([^=]*\)=.*/\1/p')

SET_NAME=$(echo "${PATCH}" | grep '^+')

#echo "${SET_NAME}" > 1

# Keeping original IFS
OLD_IFS=$IFS
IFS=$'\n'
for line in ${SET_NAME}
do
    # Remove first char '+'
    str="${line:1}"
    if test "${str}" != "";then
        first_char=$(echo "${str}" | cut -c1)

        # ignore line +++ 
        if test "${first_char}" != "+";then
            if test "${first_char}" != "#";then
                echo "${str}" >> ${OPT_CFG}
            else
                # Maybe this line is # xxx is not set
                echo "${str}" | grep -q "is not set"
                if test $? = 0; then
                    echo "${str}" >> ${OPT_CFG}
                fi
            fi

        fi
    fi
done

for line in ${NOT_SET_NAME}
do
    echo "$PATCH" | grep -q "+${line}="
    if test $? != 0; then
        echo "# $line is not set" >> ${OPT_CFG}
    fi
done
