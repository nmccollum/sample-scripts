#!/bin/bash

COLUMN=$(tput cols)
INSTMOD=$(dmidecode -t 17 | grep "Size:" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed -e 's/Size: //g')
NODEMEM=`free | grep Mem | awk '{print $2}'`
f () { echo "scale=20; a=($1); scale=0; b=a/1; if (a==b) b else b+1" | bc -l; }
NODEMEMGB=`f "$NODEMEM / ( 1024 * 1024 )"`
PHYRAM=$(dmidecode -t 17 | grep "Size:" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed -e 's/Size: //g' | grep MB | awk '{s+=$1} END {print s}')
RAMAVAIL=$(free -m | grep Mem | awk '{print $2}')

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "_"
printf "This script will calculate the amount of RAM currently in the system using dmidecode and calculate how much RAM the linux kernel can see.  Hopefully this will help you determine if a system is missing RAM.  -Nick \n"

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "_"
printf "What stick of RAM is in each slot?\n"
printf "$INSTMOD\n" | while read line; do
        SLOT=$((SLOT+1))
        printf "Slot $SLOT: $line\n"
done | column -c $COLUMN
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "_"
printf "According to my caclulations, the machine should have a total of $PHYRAM MB installed...\n"
printf "Currently the linux kernel see's $RAMAVAIL MB available, for a difference of $(( PHYRAM - $RAMAVAIL)) MB.\n"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "_"
if [[ $((PHYRAM - $RAMAVAIL)) > "500" ]]; then
        printf "Conclusion? \t Looks like you have some RAM missing!\n"
        else
        printf "Conclusion? \t Looks like you're good!"
fi
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "_"
