#!/bin/bash

# Bash program to activate or deactivate the mixing of audio and video
# playback and recording channels
# Created by: Gustavo Islas Gálvez
# Generation Date: Friday, January 09, 2026. (5th Version)

# Function to deactivate and clean the Stream mode
disable_stream()
{
	$(which echo) "Restoring original settings..."

	# Download loopback and null-sink modules by name if they exist
	$(which pactl) unload-module module-loopback
	$(which pactl) unload-module module-null-sink
	$(which pactl) unload-module module-remap-sink

	# Set the sink (output) as default
	$(which pactl) set-default-sink "$(pactl get-default-sink)"

	$(which echo) ""
	$(which echo) "Resetting all applications to the default sink... ($(pactl get-default-sink))..."

	# Move all applications back to the default sink
	$(which pactl) list short sink-inputs |
	while read -r line; do
		# We obtain the application index
		$(which echo) "$line" | $(which mawk) '{print $1}'
		app_index=$($(which echo) "$line" | $(which mawk) '{print $1}')
		$(which pactl) move-sink-input "$app_index" "$(pactl get-default-sink)"
	done

	# Determine that the standard audio options have been successfully restored
	$(which echo) ""
	$(which echo) "Normal audio settings restored successfully!"
}

# Function to activate the Stream mode
enable_stream()
{
	$(which echo) "Enabling audio settings for Stream..."
	$(which echo) "Number of parameters : $#"
	$(which echo) "List of Parameters   : $*"
	view_available_devices	# View available installed audio devices

	# Assigning the new virtual devices to their respective source (input) and sink (output) files
	$(which echo) ""
	$(which echo) "Generating new virtual source-combining devices..."

	# Create the virtual channel like '$1' and its description like '$2'
	$(which pactl) load-module module-null-sink sink_name="$1" sink_properties="device.description='$2'" ||
	{ $(which echo) "Error loading null-sink."; exit 1; }

	# Connect the channel source to the recording stream output (source, input)
	# Output loopback (speakers)
	$(which pactl) load-module module-loopback source="$(pactl get-default-source)" sink="$1" ||
	{ $(which echo) "Error loading loopback for source (input)."; disable_stream; }

	# Connect the channel sink to the playback stream input (sink, output)
	# Input loopback (microphone)
	$(which pactl) load-module module-loopback source="$(pactl get-default-sink)" sink="$1" ||
	{ $(which echo) "Error loading loopback for sink (output)."; disable_stream; }

	# Remapping the output sink to the specified destination source
	$(which pactl) load-module module-remap-sink source="$1.monitor" sink_name="$1_$3" master="$(pactl get-default-sink)" sink_properties="device.description='$1_$2_$3'"

	# Set the sink (output) as default
	$(which pactl) set-default-sink "$1_$3"

	# Redirect all applications to the combined sink
	$(which echo) ""
	$(which echo) "Redirecting all applications to the combined sink... ($1_$3)..."

	# Get the names of all audio applications and redirect them to the combined sink
	$(which pactl) list short sink-inputs |
	while read -r line; do
		# We obtain the application index
		$(which echo) "$line" | $(which mawk) '{print $1}'
		app_index=$($(which echo) "$line" | $(which mawk) '{print $1}')
		$(which pactl) move-sink-input "$app_index" "$1_$3"
	done

	# Full establishment of the new audio transmission channel
	$(which echo) ""
	$(which echo) "Done!"
	$(which echo) "Don't forget to configure '$1_$3' to output the music to '$2'."
}

# Function to list the devices available on the system
list_of_devices()
{
	$(which echo) "Linked sound devices."
	$(which echo) "+ Output devices (sinks)."
	$(which pactl) list short sinks

	$(which echo) ""
	$(which echo) "+ Input devices (sources)."
	$(which pactl) list short sources
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

# Function to briefly display the devices enabled in the system
view_available_devices()
{
	$(which echo) "Available Devices."
	$(which echo) "+ Source Input : $(pactl get-default-source)"	# Sources are input
	$(which echo) "+ Sink Output  : $(pactl get-default-sink)"	# Sinks are output
}

# Simple menu
counter=0
option=0
my_date=$($(which date) "+%A, %B %d, %Y - %H:%M:%S")

# Check variables with the path of each key command
verify_command "date"
my_date_directory=$(which date)		# date command route

verify_command "echo"
my_echo_directory=$(which echo)		# echo command route

verify_command "pactl"
my_pactl_directory=$(which pactl)	# pactl command route

# Decision control if PulseAudio is installed
if [[ -f $my_date_directory && -f $my_echo_directory && -f $my_pactl_directory ]]
then
	$(which echo) $my_date
	$(which echo) "Control a running PulseAudio sound server."
	$(which echo) $my_date_directory $my_echo_directory $my_pactl_directory

	while [ $option -ne 5 ]
	do
		$(which echo) ""
		$(which date)
		$(which echo) "+===+====+===+===+====+===+====+===+====+"
		$(which echo) "|Audio Mix Control for Ubuntu GNU/Linux.|"
		$(which echo) "+===+====+===+===+====+===+====+===+====+"
		$(which echo) "| [1]. Activate Stream mode.            |"
		$(which echo) "| [2]. Deactivate Stream and clean mode.|"
		$(which echo) "| [3]. List enable devices.             |"
		$(which echo) "| [4]. View available devices.          |"
		$(which echo) "| [5]. Leave this program.              |"
		$(which echo) "+===+====+===+===+====+===+====+===+====+"
		read -p "Select one option (1-5): " option

		if [ $? -eq 0 ]; then $(which echo) "Choice: [" $option "]."; else $(which echo) "Exit Code: [" $? "]"; fi

		counter=$(( $counter + 1 ))
		$(which echo) ""
		$(which date) "+%Y-%m-%d - %H:%M:%S"
		$(which echo) "Selected option: [$option]."
		$(which echo) "Attempts made:   [$counter]."
		$(which echo) "User active:     [$USER]."
		$(which echo) "User folder:     [$HOME]."
		$(which echo) "Key Operation:   [$RANDOM]."
		$(which echo) ""

		if [ $option -eq 1 ]; then
			enable_stream "Stream_Mix" "Mix_For_Stream" "My_Output"
		elif [ $option -eq 2 ]; then
			disable_stream
		elif [ $option -eq 3 ]; then
			list_of_devices
		elif [ $option -eq 4 ]; then
			view_available_devices
		elif [ $option -eq 5 ]; then
			$(which echo) "Leaving this program..."
			break
		else
			$(which echo) "Invalid option: [$option]. Please correct it!"
		fi
	done
else
	$(which echo) "PulseAudio sound server does not activate!"
	$(which echo) $my_date_directory
	$(which echo) $my_echo_directory
	$(which echo) $my_pactl_directory
fi

$(which echo) ""
$(which echo) "This script had a return code of: [$?]."
