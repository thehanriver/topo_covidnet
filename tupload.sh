#!/bin/bash
#
# Add plugins specifically for the topological COVIDNET feedflow.
#

./plugin_add.sh  "\
			fnndsc/pl-lungct,		\
			fnndsc/pl-med2img,		\
			fnndsc/pl-covidnet,		\
			fnndsc/pl-topologicalcopy,	\
			fnndsc/pl-pdfgeneration,	\
			jonocameron/pl-rank,		\
			thehanriver/pl-demo		\
			fnndsc/pl-lungct^AWS,		\
			fnndsc/pl-med2img^AWS,		\
			fnndsc/pl-covidnet^AWS,	\
			fnndsc/pl-topologicalcopy^AWS,\
			fnndsc/pl-pdfgeneration^AWS,	\
			jonocameron/pl-rank^AWS,	\
			thehanriver/pl-demo^AWS		
"

#
# Adding additional users
# Users can be added using some specific variation of the
# following:
#
# CUBE USERS
# For "superusers"
#####user_add.sh -U "rudolph:rudolph1234:rudolph.pienaar@gmail.com"
# For "normal users"
#####user_add.sh    "rpienaar:rudolph1234:rppienaar@gmail.com"
#
# STORE USERS
# For "superusers"
#####user_add.sh -U -S "rudolph:rudolph1234:rudolph.pienaar@gmail.com"
# For "normal users"
#####user_add.sh -S    "rpienaar:rudolph1234:rppienaar@gmail.com"
#

