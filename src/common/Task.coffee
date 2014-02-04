##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the possible priorities of a task
#
TaskPriority =
    # Priority: Are being rescheduled by 10s
    Lowest  : 10000

    # Priority: Are being rescheduled by 2.5s
    Low     : 2500

    # Priority: Are being rescheduled by 1.0s
    Normal  : 1000

    # Priority: Are being rescheduled by 0.5s
    High    : 500

    # Priority: Are being rescheduled by 0.25s
    Highest : 250

    # Priority: Never rescheduled
    Monitor : 0

#
# Define a task to be executed by the scheduler
#
class Task
    #
    # Default constructor
    #
    # \param _asCallback The callback of this task
    # \param _asTime     The next execution tick time
    # \param _asPeriod   The repetitive tick time
    # \param _asPriority The priority of thie task
    # \param _isParallel True if task runs in parallel
    #
    constructor: (@_asCallback, @_asTime, @_asPeriod, @_asPriority, @_isParallel) ->
        @_isCancelled = false

    #
    # Sets the name of the task
    #
    # \param asName The name of the task
    #
    setName: (@_asName = "Task") ->
        return

    #
    # Return the name of the task
    #
    getName: ->
        return @_asName

    #
    # Return if the task is being repeating
    #
    isRepeating: ->
        return @_asPeriod > 0

    #
    # Return if the task runs in parallel
    #
    isParallel: ->
        return @_isParallel

    #
    # Return if the task is cancelled
    #
    isCancelled: ->
        return @_isCancelled

    #
    # Set the cancellation of this task
    #
    setCancelled: (@_isCancelled = true) ->
        return

    #
    # Return the priority of this task
    #
    getPriority: ->
        return @_asPriority

    #
    # Return the next tick of this task
    #
    getTime: ->
        return @_asTime

    #
    # Return the repetitive tick of this task
    #
    getPeriod: ->
        return @_asPeriod

    #
    # Execute the task callback
    #
    # \param asArguments The arguments of the callback
    #
    run: (asArguments...) ->
        # Forward the call to the arguments and return
        # if the callback returns anything
        _asCallback(asArguments)
        return