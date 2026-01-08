#!/bin/bash

# Bash program to activate or deactivate the mixing of audio and video
# playback and recording channels.
# Created by: Gustavo Islas Gálvez.
# Generation Date: Thursday, January 08, 2026. (2nd Version).

# Function to deactivate and clean
disable_stream()
{
	echo "Restoring original settings..."

	# Download loopback and null-sink modules by name if they exist
	pactl unload-module module-loopback
	pactl unload-module module-null-sink
	pactl unload-module module-remap-sink

	# Set the sink (output) as default
	pactl set-default-sink "$(pactl get-default-sink)"

	echo ""
	echo "Resetting all applications to the default sink... ($(pactl get-default-sink))..."

	# Move all applications back to the default sink
	pactl list short sink-inputs |
	while read -r line; do
		# We obtain the application index
		echo "$line" | mawk '{print $1}'
		app_index=$(echo "$line" | mawk '{print $1}')
		pactl move-sink-input "$app_index" "$(pactl get-default-sink)"
	done

	echo ""
	echo "Normal audio settings restored successfully!"
}

# Function to activate Stream mode
enable_stream()
{
	echo "Enabling audio settings for Stream..."
	echo "Number of parameters : $#"
	echo "List of Parameters   : $*"
	view_available_devices	# View available installed audio devices

	# Assigning the new virtual devices to their respective source (input) and sink (output) files
	echo ""
	echo "Generating new virtual source-combining devices..."

	# Create the virtual channel like '$1' and its description like '$2'
	pactl load-module module-null-sink sink_name="$1" sink_properties="device.description='$2'" ||
	{ echo "Error loading null-sink."; exit 1; }

	# Connect the channel source to the recording stream output (source, input)
	# Output loopback (speakers)
	pactl load-module module-loopback source="$(pactl get-default-source)" sink="$1" ||
	{ echo "Error loading loopback for source (input)."; disable_stream; }

	# Connect the channel sink to the playback stream input (sink, output)
	# Input loopback (microphone)
	pactl load-module module-loopback source="$(pactl get-default-sink)" sink="$1" ||
	{ echo "Error loading loopback for sink (output)."; disable_stream; }

	# Remapping the output sink to the specified destination source
	pactl load-module module-remap-sink source="$1.monitor" sink_name="$1_$3" master="$(pactl get-default-sink)" sink_properties="device.description='$1_$2_$3'"

	# Set the sink (output) as default
	pactl set-default-sink "$1_$3"

	# Redirect all applications to the combined sink
	echo ""
	echo "Redirecting all applications to the combined sink... ($1_$3)..."

	# Get the names of all audio applications and redirect them to the combined sink
	pactl list short sink-inputs |
	while read -r line; do
		# We obtain the application index
		echo "$line" | mawk '{print $1}'
		app_index=$(echo "$line" | mawk '{print $1}')
		pactl move-sink-input "$app_index" "$1_$3"
	done

	echo ""
	echo "Done!"
	echo "Don't forget to configure '$1_$3' to output the music to '$2'."
}

# Function to list the devices available on the system
list_of_devices()
{
	echo "Linked sound devices."
	echo "+ Output devices (sinks)."
	pactl list short sinks

	echo ""
	echo "+ Input devices (sources)."
	pactl list short sources
}

view_available_devices()
{
	echo "Available Devices."
	echo "+ Source Input : $(pactl get-default-source)"	# Sources are input
	echo "+ Sink Output  : $(pactl get-default-sink)"	# Sinks are output
}

# Simple menu
counter=0
option=0
my_date=$(date "+%A, %B %d, %Y - %H:%M:%S")
my_pactl_directory=$(which pactl)

# Decision control if PulseAudio is installed.
if [ -f $my_pactl_directory ]
then
	echo "$my_date"
	echo "Control a running PulseAudio sound server."

	while [ $option -ne 5 ]
	do
		echo ""
		date
		echo "+===+====+===+===+====+===+====+===+====+"
		echo "|Audio Mix Control for Ubuntu GNU/Linux.|"
		echo "+===+====+===+===+====+===+====+===+====+"
		echo "| [1]. Activate Stream mode.            |"
		echo "| [2]. Deactivate Stream and clean mode.|"
		echo "| [3]. List enable devices.             |"
		echo "| [4]. View available devices.          |"
		echo "| [5]. Leave this program.              |"
		echo "+===+====+===+===+====+===+====+===+====+"
		read -p "Select one option (1, 2, 3, 4 or 5): " option

		counter=$(( $counter + 1 ))
		echo ""
		echo "Selected option: [$option]."
		echo "Attempts made:   [$counter]."
		echo ""

		if [ $option -eq 1 ]; then
			enable_stream "Stream_Mix" "Mix_For_Stream" "My_Output"
		elif [ $option -eq 2 ]; then
			disable_stream
		elif [ $option -eq 3 ]; then
			list_of_devices
		elif [ $option -eq 4 ]; then
			view_available_devices
		elif [ $option -eq 5 ]; then
			echo "Leaving this program..."
			break
		else
			echo "Invalid option: [$option]. Please correct it!"
		fi
	done
else
	echo "PulseAudio sound server does not activate!"
	echo $my_pactl_directory
	exit 1
fi
