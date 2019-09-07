#!/bin/bash

statementsLog="EP-stavovi.txt"
delimiter="|"
# flush previous
echo > "$statementsLog"

# she was an MP of the EP in 3 terms: lists of her opinions are available here:
# http://www.europarl.europa.eu/meps/en/119434/DUBRAVKA_SUICA/all-activities/plenary-speeches/7
# http://www.europarl.europa.eu/meps/en/119434/DUBRAVKA_SUICA/all-activities/plenary-speeches/8
# http://www.europarl.europa.eu/meps/en/119434/DUBRAVKA_SUICA/all-activities/plenary-speeches/9

# might also be possible to force everything in a specific language (EN, HR), but not sure if all opinions published in both languages

for file in Contributions*th*.html ; do
	linkKey="href.*europarl.*CRE"

	for link in `grep "$linkKey" "$file" | sed 's/^[ \t]*//g' | sed 's/ target="_blank"//g' | sed 's/.*"\([^"]*\)".*/\1/g'` ; do
		linkInContext=`grep -A 25 -F "$link" "$file"`
		title=`echo "$linkInContext" | grep -A 5 "activity-title" | tr '\n' ' ' | sed 's/<[^>]*>//g' | sed 's/[\t]*//g' | sed 's/&nbsp;//g' | sed 's/  */ /g'`
		date=`echo "$linkInContext" | grep -A 2 "layout_date" | tail -n 1 | sed 's/<[^>]*>//g' | sed 's/[\t]*//g'`

		echo -n "${link}${delimiter}" >> "$statementsLog"
		echo -n "${title}${delimiter}" >> "$statementsLog"
		echo -n "${date}${delimiter}" >> "$statementsLog"

		wget "$link" -O - | tr '\n' ' ' | sed 's/.*\(<p class="contents">.*Dubravka .uica.*\)/\1/g' | sed 's/<\/p>.*//g' | sed 's/<[^>]*>//g' >> "$statementsLog"
		#echo -e "\n\n---\n" >> "$statementsLog"
		#echo -e "\n" >> "$statementsLog"
	done
done
