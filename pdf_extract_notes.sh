#!/bin/bash

# This script uses "Preview" to extract the annotations and notes of pdf files into a text file
# Since there is no public API for extracting the annotations, it scraps them from the UI of "Preview"

# NOTE: you will be asked to grand the "Terminal" the right to control your computer 
#       and you have to allow this in your systems settings

# WARNING: For this reason, the script might have to be adapted in future versions of "Preview"



GESTERN_TIME=$((`date +%s` - 1 * 86400))
GESTERN=`date -r $GESTERN_TIME '+%d.%m.%Y'`

VORGESTERN_TIME=$((`date +%s` - 2 * 86400))
VORGESTERN=`date -r $VORGESTERN_TIME '+%d.%m.%Y'`

FORCE=0
FILES="$@"

for i in $FILES; do
	if [ $i = "-f" ]; then FORCE=1; continue; fi
	NoteFile="`basename "$i" .pdf`.note"		
	if `[ ! -e "$NoteFile" ] || [ $FORCE == 1 ] || [ "$i" -nt "$NoteFile"  ]`; then
	echo "Extracting Marker and Notes from: "$i
	open "$i"
	osascript -e 'tell application "Preview" to activate
tell application "System Events"
	tell process "Preview"
		-- open "markers & notes"
		keystroke 4 using {command down, option down}
		-- find the UI element of "markers & notes"
		set c to (rows of table 1 of scroll area 1 of splitter group 1 of UI element 1)
		-- gather the annotations in "s"
		set s to ""
		-- (items 1 thru 10 of c)
		repeat with ea in c
		try
       		set a to UI element 1 of ea
			-- get value of UI element 4 of a
			set r to get value of static text of a
			set s to s & "Page: " & item 1 of r & "\nStamp: " & (item 2 of r) & "\nMarked: " & (item 3 of r)
			set n to (get value of UI element 4 of a)
			-- optionally get the not 
			if (n is missing value) then
			else
				set s to s & "\nNote: " & n
			end if		
			set s to s & "\n\n"
		on error errmsg

     		set s to s & "Error: " & errmsg & "\n\n" 
		end try
		end repeat
		return s
	end tell
end tell' | sed 's/^Stamp: Ich - /Stamp: '`whoami`' - /'  | 
	sed 's/^\(Stamp: .* - \)Heute/\1'`date  +"%d.%m.%Y"`'/' |
	sed 's/^\(Stamp: .* - \)Gestern/\1'$GESTERN'/' |	
	sed 's/^\(Stamp: .* - \)Vorgestern/\1'$GESTERN'/' > "$NoteFile"
osascript -e 'tell application "Preview" to close document 1 '
	else
		echo "skipping "$i
	fi
done