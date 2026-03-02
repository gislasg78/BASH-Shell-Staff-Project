#!/bin/bash

# Bash program. Its purpose is to readjust and restore
# the keyboard state to default values
# Created by: Gustavo Islas Gálvez
# Generation Date: Monday, March 02, 2026. (4th Version)

# Function to fully restore keyboard control
restore_control_keyboard()
{
	# Clarifying keyboard control services...
	$(which echo) "Clarifying keyboard control services..."
	$(which xmodmap) -e "clear control" || { $(which echo) "An error occurred while executing the instruction."; }

	# Resetting keyboard control services...
	$(which echo) ""
	$(which echo) "Resetting keyboard control services..."
	$(which xmodmap) -e "add control = Control_L Control_R" || { $(which echo) "An error occurred while executing the instruction."; }

	# The configurations were carried out with resounding success!
	$(which echo) ""
	$(which echo) "Done!"
	$(which echo) "The configurations were carried out with resounding success!"
}

# Function to reset the keyboard's default configuration map.
restore_map_keyboard()
{
	# Reset resource settings.
	$(which echo) "Resetting resource setting..."
	sudo $(which dconf) reset -f /org/gnome/desktop/input-sources/

	# Setting default keyboard configuration...
	$(which echo) "Setting default keyboard configuration..."
	$(which setxkbmap) -layout es || { $(which echo) "An error occurred while executing the instruction."; }
}

# Function to restore essential keyboard services.
restore_service_keyboard()
{
	# Restoring basic keyboard services...
	$(which echo) "Restoring basic keyboard services..."

	# Restoring the keyboard to its original state.
	sudo service keyboard-setup restart || { $(which echo) "An error occurred while executing the instruction."; }

	# Basic keyboard services in OK state!
	$(which echo) ""
	$(which echo) "Basic keyboard services restored successfully!"
}

# Function that checks and verifies the existence of the commands necessary for this test script.
verify_command()
{
	local my_command_directory=$(which $1)

	$(which echo) "Routine for verifying the valid existence of commands."

	if [ -f $my_command_directory ]
	then
		$(which echo) "The command: [$my_command_directory] is installed in the path: [$(which $my_command_directory)]."

		if command -v $my_command_directory
		then
			$(which echo) "The command: [$my_command_directory] is fully enabled!"
		else
			$(which echo) "The command: [$1] is not possible to run it!"
		fi
	else
		$(which echo) "The command: [$1] is not installed!"
	fi

	$(which echo) ""
}

# Simple menu
counter=0
option=0
my_date=$($(which date) "+%A, %B %d, %Y - %H:%M:%S")

# Check variables with the path of each key command
verify_command "date"
my_date_directory=$(which date)			# date command route

verify_command "dconf"
my_dconf_directory=$(which dconf)		# dconf command route

verify_command "echo"
my_echo_directory=$(which echo)			# echo command route

verify_command "setxkbmap"
my_setxkbmap_directory=$(which setxkbmap)	# setxkbmap command route

verify_command "xmodmap"
my_xmodmap_directory=$(which xmodmap)		# xmodmap command route

# Decision control if PulseAudio is installed.
if [[ -f $my_date_directory && -f $my_dconf_directory && -f $my_echo_directory && -f $my_setxkbmap_directory && -f $my_xmodmap_directory ]]
then
	$(which echo) "$my_date"
	$(which echo) "Utility for modifying keymaps."

	while [ $option -ne 7 ]
	do
		$(which echo)""
		$(which date)
		$(which echo) "+===+====+===+===+====+===+====+=="
		$(which echo) "|   Keyboard Control Services.   |"
		$(which echo) "+===+====+===+===+====+===+====+=="
		$(which echo) "| [1]. Restore control keyboard. |"
		$(which echo) "| [2]. Restore map keyboard.     |"
		$(which echo) "| [3]. Restore service keyboard. |"
		$(which echo) "| [4]. Run key detector.         |"
		$(which echo) "| [5]. Restart GDM3 system.      |"
		$(which echo) "| [6]. Rehabilitate Gnome-Shell. |"
		$(which echo) "| [7]. Exit this program.        |"
		$(which echo) "+===+====+===+===+====+===+====+=="
		read -p "Select one option (1-7): " option

		if [ $? -eq 0 ]; then $(which echo) "Choice: [" $option "]."; else $(which echo) "Exit Code: [" $? "]"; fi

		counter=$(( $counter + 1 ))
		$(which echo) ""
		$(which date) "+%Y-%m-%d - %H:%M:%S"
		$(which echo) "Selected option: [$option]."
		$(which echo) "Attempts made:   [$counter]."
		$(which echo) "Current PID:     [$$]."
		$(which echo) "Father  PID:     [$PPID]."
		$(which echo) "User active:     [$USER]."
		$(which echo) "User folder:     [$HOME]."
		$(which echo) "Key Random Oper: [$RANDOM]."
		$(which echo) ""

		case $option in
			1) $(which echo) "Control Keyboard.";;
			2) $(which echo) "Map Keyboard.";;
			3) $(which echo) "Service Keyboard.";;
			4) $(which echo) "Key Detector.";;
			5) $(which echo) "GDM3 Restart.";;
			6) $(which echo) "Gnome-Shell restart.";;
			7) $(which echo) "Exiting this program...";;
			*) $(which echo) "Wrong choice: [" $option "]."
		esac

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
			sudo killall gnome-shell
		elif [ $option -eq 7 ]; then
			$(which echo) "Leaving this program..."
			break
		else
			$(which echo) "Invalid option: [$option]. Please correct it!"
		fi
	done
else
	$(which echo) "Utility for modifying keymaps does not activate!"
	$(which echo) $my_date_directory
	$(which echo) $my_dconf_directory
	$(which echo) $my_echo_directory
	$(which echo) $my_setxkbmap_directory
	$(which echo) $my_xmodmap_directory
fi

$(which echo) ""
$(which echo) "This script had a return code of: [$?]."
