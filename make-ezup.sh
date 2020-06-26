#!/bin/dash

# Dependencies: recode, sed
rm -rf .web && mkdir .web

TITLE="<b>Dash Eclipse's Personal Site</b> (ezup.dev)"

TREE="$(echo '<b>></b> <b style="color:#2da602;">tree</b> ../ezup.dev')\n$(tree ../ezup.dev \
	| sed 's# about.txt# <a href="about.html">about.txt</a>#' \
	| sed 's# gpg.txt# <a href="gpg.html">gpg.txt</a>#' \
	| sed 's# neofetch.txt# <a href="neofetch.html">neofetch.txt</a>#' \
	| sed 's# dashezup-pubkey.asc# <a href="keys/dashezup-pubkey.asc">dashezup-pubkey.asc</a>#' \
	| sed 's#https://ezup.dev/stagit/#<a href="https://ezup.dev/stagit/" target="_blank">https://ezup.dev/<b>stagit/</b></a>#')\n$(echo '<b>></b> ')"

HEAD=$(cat <<-EOM
<head>
  <title>Dash Eclipse's Personal Site</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Dash Eclipse's Personal Site">
  <meta name="keywords" content="Dash Eclipse, dashezup, EZUP, EasyUP Dev">
  <meta name="author" content="Dash Eclipse">
  <style>
  a:link {
    color: #6871ff;
  }
  a:visited {
  color: #005bbb;
  }
  </style>
</head>
EOM
)

for txt in about.txt gpg.txt index.txt neofetch.txt; do
	if [ "$txt" = "index.txt" ]; then
		BOLD_TREE=$(echo "$TREE" | sed 's# ../ezup.dev# <a href="./" style="background-color:\#b4d5fe\;"><b>../ezup.dev</b></a>#')
	else
		BOLD_TREE=$(echo "$TREE" | sed 's# ../ezup.dev# <a href="./"><b>../ezup.dev</b></a>#' \
			| sed "s|>$txt<|><b style="background-color:\#b4d5fe\;">$txt</b><|")
	fi
	TEXT=$(cat $txt | recode ascii..html \
		| sed 's#^$ gpg #<b style="color:\#0225c7">dash</b>@ezup <b>~/git/ezup.dev</b> % <b style="color:\#00c200\;">gpg</b> #' \
		| sed 's#^$ curl #<b style="color:\#0225c7">dash</b>@ezup <b>~/git/ezup.dev</b> % <b style="color:\#00c200\;">curl</b> #' \
		| sed 's#^$ cmatrix #<b style="color:\#0225c7">dash</b>@ezup <b>~/git/ezup.dev</b> % <b style="color:\#00c200\;">cmatrix</b> #' \
		| sed 's#^$ neofetch #<b style="color:\#0225c7">dash</b>@ezup <b>~/git/ezup.dev</b> % <b style="color:\#00c200\;">neofetch</b> #' \
		| sed 's#^$ _#<b style="color:\#0225c7">dash</b>@ezup <b>~/git/ezup.dev</b> % #' \
		| sed "s#Source Code of Dash Eclipse's Personal Site#<a href=\"https://ezup.dev/stagit/ezup.dev/\" target="_blank">Source Code of Dash Eclipse's Personal Site</a>#" \
		| sed 's#67965F307B110019691461A12463834FFD2CBDBB#<b>67965F307B110019691461A12463834FFD2CBDBB</b>#' \
		| sed 's#1084CEB0AFC0F003132F8F604802C6B37F40927D#<b>1084CEB0AFC0F003132F8F604802C6B37F40927D</b>#' \
		| sed 's#keys/dashezup-pubkey.asc#<a href="keys/dashezup-pubkey.asc">keys/dashezup-pubkey.asc</a>#')
	if [ "$txt" = "about.txt" ]; then
		TEXT=$(echo "$TEXT" | sed 's#About Dash Eclipse#<b><i>About Dash Eclipse</i></b>#' \
		| sed 's#About the Website#<b><i>About the Website</i></b>#' \
		| sed 's#Programmer Dvorak#<a href="https://www.kaufmann.no/roland/dvorak/" target="_blank">Programmer Dvorak</a>#' \
		| sed 's#pass$#<a href="https://www.passwordstore.org/" target="_blank">pass</a>#')
	fi
	SEPARATOR="<b>───────────────────────────────────────────────────────────────────────────</b>"
	HTML_TEXT="${TITLE}\n\n${BOLD_TREE}\n${SEPARATOR}\n\n${TEXT}"
	BODY="<body>\n<pre style=\"margin: 25px 20px 25px;\">${HTML_TEXT}</pre>\n</body>"
	echo "<!DOCTYPE html>\n<html>\n$HEAD\n$BODY\n</html>" >.web/$(basename $txt .txt).html
done

sed -i "/<meta name=\"description\"/s/Dash Eclipse's Personal Site/About Dash Eclipse/" .web/about.html
sed -i "/<meta name=\"description\"/s/Dash Eclipse's Personal Site/Dash Eclipse's GPG Key/" .web/gpg.html
sed -i "/<meta name=\"description\"/s/Dash Eclipse's Personal Site/Dash Eclipse's neofetch/" .web/neofetch.html

cp -H -R keys .web/
