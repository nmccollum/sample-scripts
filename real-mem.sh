#!/bin/bash

COLUMNS=$(tput cols)
if [[ $COLUMNS > "120" ]]; then
        COLUMNS="120"
fi

# I like pretty lines
printf '%*s\n' "${COLUMNS}" '' | tr ' ' "_"
printf "This script will calculate the amount of RAM currently in the system using dmidecode and calculate how much RAM the linux kernel can see.  Hopefully this will help you determine if a system is missing RAM.  -Nick \n" | fold -s -w $COLUMNS

# This will print what size stick is in each slot on the motherboard
printf '%*s\n' "${COLUMNS}" '' | tr ' ' "_"
printf "What stick of RAM is in each slot?\n"
INSTMOD=$(dmidecode -t 17 | grep "Size:" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed -e 's/Size: //g')
printf "$INSTMOD\n" | while read line; do
        SLOT=$((SLOT+1))
        printf "Slot $SLOT: $line\n"
done | column -c $COLUMNS

# Do some math to see how much is installed versus how much the kernel sees
printf '%*s\n' "${COLUMNS}" '' | tr ' ' "_"
RAMAVAIL=$(free -m | grep Mem | awk '{print $2}')
PHYRAM=$(dmidecode -t 17 | grep "Size:" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed -e 's/Size: //g' | grep MB | awk '{s+=$1} END {print s}')
printf "According to my caclulations, the machine should have a total of $PHYRAM MB installed...\n"
printf "Currently the linux kernel see's $RAMAVAIL MB available, for a difference of $(( PHYRAM - $RAMAVAIL)) MB. There is normally a difference in how much is available versus how much is installed.  The linux kernel dedicates a certain amount of RAM to itself that cannot be used for anything else.\n" | fold -s -w $COLUMNS

# Tell the user if they are missing ram or not
printf '%*s\n' "${COLUMNS}" '' | tr ' ' "_"
if [[ $((PHYRAM - $RAMAVAIL)) > "500" ]]; then
        printf "Conclusion? \t Looks like you have some RAM missing!\n"
        else
        printf "Conclusion? \t Looks like you're good!\n"
fi
printf '%*s\n' "${COLUMNS}" '' | tr ' ' "_"
