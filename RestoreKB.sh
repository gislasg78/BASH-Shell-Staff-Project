#!/bin/bash

# Bash program. Its purpose is to readjust and restore
# the keyboard state to default values
# Created by: Gustavo Islas Gálvez
# Generation Date: Thursday, January 08, 2026. (1st Version)

# Function to fully restore keyboard control
restore_control_keyboard()
{
	# Clarifying keyboard control services...
	echo "Clarifying keyboard control services..."
	xmodmap -e "clear control" || { echo "An error occurred while executing the instruction."; }

	# Resetting keyboard control services...
	echo ""
	echo "Resetting keyboard control services..."
	xmodmap -e "add control = Control_L Control_R" || { echo "An error occurred while executing the instruction."; }

	# The configurations were carried out with resounding success!
	echo ""
	echo "Done!"
	echo "The configurations were carried out with resounding success!"
}

# Function to reset the keyboard's default configuration map.
restore_map_keyboard()
{
	# Setting default keyboard configuration...
	echo "Setting default keyboard configuration..."
	setxkbmap -layout es || { echo "An error occurred while executing the instruction."; }
}

# Function to restore essential keyboard services.
restore_service_keyboard()
{
	# Restoring basic keyboard services...
	echo "Restoring basic keyboard services..."

	# Restoring the keyboard to its original state.
	sudo service keyboard-setup restart || { echo "An error occurred while executing the instruction."; }

	# Basic keyboard services in OK state!
	echo ""
	echo "Basic keyboard services restored successfully!"
}

# Simple menu
counter=0
option=0
my_date=$(date "+%A, %B %d, %Y - %H:%M:%S")
my_xmodmap_directory=$(which xmodmap)

# Decision control if PulseAudio is installed.
if [ -f $my_xmodmap_directory ]
then
	echo "$my_date"
	echo "Utility for modifying keymaps."

	while [ $option -ne 6 ]
	do
		echo ""
		date
		echo "+===+====+===+===+====+===+====+=="
		echo "|   Keyboard Control Services.   |"
		echo "+===+====+===+===+====+===+====+=="
		echo "| [1]. Restore control keyboard. |"
		echo "| [2]. Restore map keyboard.     |"
		echo "| [3]. Restore service keyboard. |"
		echo "| [4]. Run key detector.         |"
		echo "| [5]. Restart GDM3 system.      |"
		echo "| [6]. Exit this program.        |"
		echo "+===+====+===+===+====+===+====+=="
		read -p "Select one option (1-6): " option

		counter=$(( $counter + 1 ))
		echo ""
		echo "Selected option: [$option]."
		echo "Attempts made:   [$counter]."
		echo "Key Operation:   [$RANDOM]."
		echo ""

		if [ $option -eq 1 ]; then
			restore_control_keyboard
		elif [ $option -eq 2 ]; then
			restore_map_keyboard
		elif [ $option -eq 3 ]; then
			restore_service_keyboard
		elif [ $option -eq 4 ]; then
			xev
		elif [ $option -eq 5 ]; then
			sudo systemctl restart gdm3
		elif [ $option -eq 6 ]; then
			echo "Leaving this program..."
			break
		else
			echo "Invalid option: [$option]. Please correct it!"
		fi
	done
else
	echo "Utility for modifying keymaps does not activate!"
	echo $my_xmodmap_directory
	exit 1
fi
