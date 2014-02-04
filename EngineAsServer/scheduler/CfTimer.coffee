##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the implementation of #{Common.Timer}
#
Scheduler.Timer = class Timer extends Common.Timer
    #
    # \no-doc
    #
    getSystemTime: ->
        return process.hrtime()