#!/bin/bash

# Sample Text
LOREM="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

# Grab terminal width
WIDTH=$(stty size | awk '{print $2}')

# Echo sample text a few times and fold it
printf "Below you will see that the text will fit the width of the screen no matter the size.\n"
eval printf -- '-%.s' {1..$WIDTH} ; echo
printf "$LOREM $LOREM $LOREM\n" | fold -s -w $WIDTH
