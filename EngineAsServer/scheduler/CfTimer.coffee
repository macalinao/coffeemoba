##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the implementation of #{Timer}
#
class CfTimer extends Timer
    #
    # \no-doc
    #
    getSystemTime: ->
        return process.hrtime()