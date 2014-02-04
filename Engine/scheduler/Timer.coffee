##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the interface for a timer implementation
#
Common.Timer = class Timer
    #
    # Return the current time of the system
    #
    getSystemTime: ->
        throw Error "Unimplemented method"