#!/bin/bash

if [ $# -eq 1 ]; then distro=$1; else distro=0; fi

while [ $distro -ne 7 ]
do
	$(which echo) "What is your favorite Linux distribution?"

	$(which echo) "[1]. Arch."
	$(which echo) "[2]. CentOS."
	$(which echo) "[3]. Debian."
	$(which echo) "[4]. Mint."
	$(which echo) "[5]. Ubuntu."
	$(which echo) "[6]. Something else..."
	$(which echo) "[7]. Exit."

	read -p "Enter a choice: " distro;

	if [ $? -ne 0 ]; then $(which echo) "An error has occurred in entering command."; else $(which echo) "Enter OK!"; fi

	$(which echo) "Your option was: [" $distro "]."

	case $distro in
		1) $(which echo) "Arch is a rolling release.";;
		2) $(which echo) "CentOS is popular on servers.";;
		3) $(which echo) "Debian is a community distribution.";;
		4) $(which echo) "Mint is popular on desktops and laptops.";;
		5) $(which echo) "Ubuntu is popular on both servers and computers.";;
		6) $(which echo) "There are many distributions out there.";;
		7) $(which echo) "Quitting this program...";;
		*) $(which echo) "You didn't enter an appropriate choice."
	esac

	$(which echo) ""
done

$(which echo) "Thank you for using this script."
$(which echo) "This program returned an error code of: [" $? "]."
