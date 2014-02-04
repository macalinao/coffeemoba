##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the possible priorities of a task
#
Common.TaskPriority = class TaskPriority extends Common.Enum
    # Enumeration size
    @_asSize   : 0

    # Enumeration values
    @_asValues : { LOWEST, LOW, NORMAL, HIGH, HIGHEST, MONITOR }

    # Priority: Are being rescheduled by 10s
    @LOWEST  : new TaskPriority(10000)

    # Priority: Are being rescheduled by 2.5s
    @LOW     : new TaskPriority(2500)

    # Priority: Are being rescheduled by 1.0s
    @NORMAL  : new TaskPriority(1000)

    # Priority: Are being rescheduled by 0.5s
    @HIGH    : new TaskPriority(500)

    # Priority: Are being rescheduled by 0.25s
    @HIGHEST : new TaskPriority(250)
    
    # Priority: Never rescheduled
    @MONITOR : new TaskPriority(0)

    #
    # Default constructor of this enumeration
    #
    # \param _asDeferredTime The deferred time
    #
    constructor : (@_asDeferredTime) ->
        super

    #
    # Returns the deferred time of the priority
    #
    getDeferredTime : ->
        return @_asDeferredTime