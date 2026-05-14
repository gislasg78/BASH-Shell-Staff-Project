#!/bin/bash

# Bash program. Its purpose is to readjust and restore
# the keyboard state to default values
# Created by: Gustavo Islas Gálvez
# Generation Date: Thursday, May 14, 2026. (8th Version)

# Function to assign the control key to the caps lock key in Gnome.
assigning_control_keys_to_caps_lock()
{
	# Assigning the Control key to the Caps Lock key.
	$(which echo) ""
	$(which echo) "Assigning the Control key to the Caps Lock key."
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
}

# Function to fully restore keyboard control
restore_control_keyboard()
{
	# Exploring keyboard settings...
	$(which echo) ""
	$(which echo) "Exploring keyboard settings..."
	sudo $(which xmodmap) -pke | $(which grep) Control

	# Clarifying keyboard control services...
	$(which echo) ""
	$(which echo) "Clarifying keyboard control services..."
	sudo $(which xmodmap) -e "clear control" || { $(which echo) "An error occurred while executing the instruction."; }

	# Resetting keyboard control services...
	$(which echo) ""
	$(which echo) "Resetting keyboard control services..."
	sudo $(which xmodmap) -e "add control = Control_L Control_R" || { $(which echo) "An error occurred while executing the instruction."; }

	# Restore keyboard default settings.
	restore_gnome_control_keys

	# The configurations were carried out with resounding success!
	$(which echo) ""
	$(which echo) "Done!"
	$(which echo) "The keyboard control settings have been reset!"
}

# Special function for assigning the control key to the caps key.
restore_gnome_control_keys()
{
	# Restore keyboard default settings.
	$(which echo) ""
	$(which echo) "Restore keyboard default settings..."
	gsettings reset org.gnome.desktop.input-sources xkb-options
}

# Function to reset the keyboard's default configuration map.
restore_map_keyboard()
{
	# Setting default keyboard hardware configurations.
	$(which echo) ""
	$(which echo) "Setting default keyboard hardware configurations..."
	sudo $(which modprobe) -r atkbd
	sudo $(which modprobe) atkbd

	# Reset resource settings.
	$(which echo) ""
	$(which echo) "Resetting resource setting..."
	$(which dconf) reset -f /org/gnome/desktop/input-sources/

	# Resetting keyboard configuration maps...
	$(which echo) ""
	$(which echo) "Resetting keyboard configuration maps..."
	sudo $(which setxkbmap) -option

	# Setting the control key not to be mapped to the Caps Lock key.
	$(which echo) ""
	$(which echo) "Setting the control key not to be mapped to Caps Lock key..."
	sudo $(which setxkbmap) -option ctrl:nocaps

	# Showing original keyboard configurations.
	$(which echo) ""
	$(which echo) "Showing original keyboard configurations."
	sudo $(which setxkbmap) -query

	# Setting default keyboard configuration...
	$(which echo) ""
	$(which echo) "Setting default keyboard configuration..."
	sudo $(which setxkbmap) -layout es || { $(which echo) "An error occurred while executing the instruction."; }

	# The configurations were carried out with resounding success!
	$(which echo) ""
	$(which echo) "Done!"
	$(which echo) "The keyboard mapping settings have been reset!"
}

# Function to restore essential keyboard services.
restore_service_keyboard()
{
	# Resetting basic keyboard services...
	$(which echo) ""
	$(which echo) "Resetting basic keyboard services..."
	sudo $(which udevadm) trigger

	# Restoring basic keyboard services...
	$(which echo) ""
	$(which echo) "Restoring basic keyboard services..."

	# Restoring the keyboard to its original state.
	sudo service keyboard-setup restart || { $(which echo) "An error occurred while executing the instruction."; }

	# The configurations were carried out with resounding success!
	$(which echo) ""
	$(which echo) "Done!"
	$(which echo) "The keyboard services settings have been reset!"
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

verify_command "evtest"
my_evtest_directory=$(which evtest)		# evtest command route

verify_command "setxkbmap"
my_setxkbmap_directory=$(which setxkbmap)	# setxkbmap command route

verify_command "showkey"
my_showkey_directory=$(which showkey)		# showkey command route

verify_command "xmodmap"
my_xmodmap_directory=$(which xmodmap)		# xmodmap command route

# Decision control if PulseAudio is installed.
if [[ -f $my_date_directory && -f $my_dconf_directory && -f $my_echo_directory && -f $my_evtest_directory && -f $my_setxkbmap_directory && -f $my_showkey_directory && -f $my_xmodmap_directory ]]
then
	$(which echo) "$my_date"
	$(which echo) "Utility for modifying keymaps."

	while [ $option -ne 11 ]
	do
		$(which echo)""
		$(which date)
		$(which echo) "+===+====+===+===+====+===+====+===+"
		$(which echo) "|     Keyboard Control Services.   |"
		$(which echo) "+===+====+===+===+====+===+====+===+"
		$(which echo) "| [01]. Restore control keyboard.  |"
		$(which echo) "| [02]. Restore map keyboard.      |"
		$(which echo) "| [03]. Restore service keyboard.  |"
		$(which echo) "| [04]. Run key detector.          |"
		$(which echo) "| [05]. Run key event detector.    |"
		$(which echo) "| [06]. Run key press display.     |"
		$(which echo) "| [07]. Launch GDM3 Control Center.|"
		$(which echo) "| [08]. Reassign ctrl to caps lock.|"
		$(which echo) "| [09]. Rerun Gnome-Shell.         |"
		$(which echo) "| [10]. Restart Gnome-Shell.       |"
		$(which echo) "| [11]. Exit this program.         |"
		$(which echo) "+===+====+===+===+====+===+====+===+"
		read -p "Select one option (1-11): " option

		if [ $? -eq 0 ]; then $(which echo) "Choice: [" $option "]."; else $(which echo) "Exit Code: [" $? "]"; fi

		counter=$(( $counter + 1 ))
		$(which echo) ""
		$(which date) "+%Y-%m-%d - %H:%M:%S"
		$(which echo) "* Selected option: [$option]."
		$(which echo) "< Attempts made:   [$counter]."
		$(which echo) "+ Current PID:     [$$]."
		$(which echo) "+ Father  PID:     [$PPID]."
		$(which echo) "- User active:     [$USER]."
		$(which echo) "- User folder:     [$HOME]."
		$(which echo) "> Key Random Oper: [$RANDOM]."
		$(which echo) ""

		case $option in
			1)  $(which echo) "** Control Keyboard. **";;
			2)  $(which echo) "** Map Keyboard. **";;
			3)  $(which echo) "** Service Keyboard. **";;
			4)  $(which echo) "** Key Detector. **";;
			5)  $(which echo) "** Key Event Detector. **";;
			6)  $(which echo) "** Key Press Display. **";;
			7)  $(which echo) "** GDM3 Control Center. **";;
			8)  $(which echo) "** Reassigning ctrl to caps. **";;
			9)  $(which echo) "** Gnome-Shell rerun. **";;
			10) $(which echo) "** Gnome-Shell restart. **";;
			11) $(which echo) "Exiting this program...";;
			*) $(which echo) "Wrong choice: [" $option "]."
		esac

		if [ $option -eq 1 ]; then
			restore_control_keyboard
		elif [ $option -eq 2 ]; then
			restore_map_keyboard
		elif [ $option -eq 3 ]; then
			restore_service_keyboard
		elif [ $option -eq 4 ]; then
			sudo $(which xev)
		elif [ $option -eq 5 ]; then
			sudo $(which evtest)
		elif [ $option -eq 6 ]; then
			sudo $(which showkey)
		elif [ $option -eq 7 ]; then
			gnome-control-center keyboard
		elif [ $option -eq 8 ]; then
			assigning_control_keys_to_caps_lock
		elif [ $option -eq 9 ]; then
			sudo $(which killall) -3 gnome-shell
		elif [ $option -eq 10 ]; then
			sudo $(which systemctl) restart gdm3
		elif [ $option -eq 11 ]; then
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
	$(which echo) $my_evtest_directory
	$(which echo) $my_setxkbmap_directory
	$(which echo) $my_showkey_directory
	$(which echo) $my_xmodmap_directory
fi

$(which echo) ""
$(which echo) "This script had a return code of: [$?]."
