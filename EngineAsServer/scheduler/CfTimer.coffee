##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the implementation of #{Common.Scheduler.Timer}
#
Scheduler.Scheduler.Timer = class Timer extends Common.Scheduler.Timer
    #
    # \no-doc
    #
    getSystemTime: ->
    	return process.hrtime()