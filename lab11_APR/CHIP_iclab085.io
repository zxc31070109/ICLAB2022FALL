######################################################
#                                                    #
#  Silicon Perspective, A Cadence Company            #
#  FirstEncounter IO Assignment                      #
#                                                    #
######################################################

Version: 2

#Example:  
#Pad: I_CLK 		W

#define your iopad location here


# NORTH
Pad:OUT_VALID    N
#
Pad: VDDP0       N
Pad: GNDP0       N
#
#
Pad: VDDC0       N
Pad: I_RESET     N
Pad: GNDC0       N
#
#
Pad: VDDP1       N
Pad: GNDP1       N
#
Pad:OUT_VALUE    N

# EAST
Pad: I_MATRIX     E
#
Pad: VDDP2       E
Pad: GNDP2       E
#
Pad: I_MATSIZE     E

#
Pad: VDDC1       E
Pad: GNDC1       E
#
Pad: I_MATSIZE2     E
#
Pad: VDDP3       E
Pad: GNDP3       E
#
# SOUTH

Pad: I_VALID     S
#
Pad: VDDP4       S
Pad: GNDP4       S
#
#
Pad: VDDC2       S
Pad: I_CLK       S
Pad: GNDC2       S
#
#
Pad: VDDP5       S
Pad: GNDP5       S
#
Pad: I_VALID2     S

#WEST
Pad: I_IMAT       W
Pad: I_WMAT       W
#
Pad: VDDP6       W
Pad: GNDP6       W
#
#
Pad: VDDC3       W
Pad: GNDC3       W
#
#
Pad: VDDP7       W
Pad: GNDP7       W
#

#
Pad: PCLR SE PCORNER
Pad: PCUL NW PCORNER
Pad: PCUR NE PCORNER
Pad: PCLL SW PCORNER