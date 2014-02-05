##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the manager of every task as a scheduler
#
class TaskManager
    #
    # Default constructor of the class
    #
    # \param _asIterationPerSecond The number of iterations per second
    # \param _asWorkerPool         The worker pool that is used by this manager
    # \param _asTimer              The timer implementation of this manager
    #
    construcctor : (@_asIterationPerSecond, @_asWorkerPool, @_asTimer) ->
        @_isActive         = true
        @_asCurrentTick    = 0
        @_asTimePerTick    = 1000 / @_asIterationPerSecond
        @_asOverloadedTick = 0

    #
    # Executes the scheduler
    #
    run : ->
        # Run the logic of the scheduler
        if (@_isActive)
            # Step into the scheduler, by running
            # one tick ahead
            stepAnAction()

        else
            # If the task manager is no lon ger available,
            # then destroy the worker pool
            @_asWorkerPool.destroy()

    #
    # Returns the current tick of the scheduler
    #
    getUptime : ->
        return @_asCurrentTick
    
    #
    # Returns how many iterations per second the scheduler is executing
    #
    getIterationPerSecond : ->
        return @_asIterationPerSecond

    #
    # Returns if the scheduler is overloaded
    #
    isOverloaded : ->
        return @_asOverloadedTick > 10

    #
    # Returns if the scheduler is currently running
    #
    isActive : ->
        return @_isActive

    #
    # Cancel the scheduler for being executed
    #
    setActive : (@_isActive = false) ->
        return

    #
    # Schedules a synchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    #
    # \return The instance of the task
    #
    addTask : (asCallback, asPriority) ->
        # Deferred the registration of the task
        # to the registrator
        return @deferredTask(asCallback, asPriority, 0, 0, false)

    #
    # Schedules a delayed synchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    # \param asDelay    The delayed tick to execute the task
    #
    # \return The instance of the task
    #
    addDelayedTask : (asCallback, asPriority, asDelay) ->
        # Deferred the registration of the task
        # to the registrator
        return @deferredTask(asCallback, asPriority, asDelay, 0, false)

    #
    # Schedules a repeating synchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    # \param asDelay    The delayed tick to execute the task
    # \param asPeriod   The repeating period tick of the task
    #
    # \return The instance of the task
    #
    addRepeatingTask : (asCallback, asPriority, asDelay, asPeriod) ->
        # Deferred the registration of the task
        # to the registrator
        return @deferredTask(asCallback, asPriority, asDelay, asPeriod, false)

    #
    # Schedules a asynchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    #
    # \return The instance of the task
    #
    addAsyncTask : (asCallback, asPriority) ->
        # Deferred the registration of the task
        # to the registrator
        return @deferredTask(asCallback, asPriority, 0, 0, true)

    #
    # Schedules a delayed asynchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    # \param asDelay    The delayed tick to execute the task
    #
    # \return The instance of the task
    #
    addAsyncDelayedTask : (asCallback, asPriority, asDelay) ->
        # Deferred the registration of the task
        # to the registrator
        return @deferredTask(asCallback, asPriority, asDelay, 0, true)

    #
    # Deferred a task into the callback's list
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    # \param asDelay    The delayed tick to execute the task
    # \param asPeriod   The repeatitive period tick of the task
    # \param isParallel True if the task runs in parallel
    #
    # \return The instance of the task
    #
    deferredTask : (asCallback, asPriority, asDelay, asPeriod, isParallel) ->
        # Build a new task with the current tick
        # of the scheduler
        asTask = new Task(asCallback, asPriority, @_asCurrentTick + asDelay, asPeriod, isParallel)

        # Deferred the task to be added when the scheduler
        # finalize it's tick time
        @_asDeferredTask.push(asTask)
        return asTask

    #
    # Step an action in the task manager
    #
    stepAnAction : ->
        asQueue      = new Queue()
        isFinished   = false
        asStartTime  = @_asTimer.getSystemTime()

        # Deferred every task to execute on this tick, the scheduler
        # find the best suitable task to be executed on this tick
        loop
            # Gets the first task to be executed
            asTask = @_asActiveTask.peek()

            # Check if the task can be executed, if not then probably
            # other task cannot be executed as well, since the first task
            # popped from a priority queue is the one likely to be executed first
            if (not asTask? and asTask.getTime() >= @_asCurrentTick)
                # Check if the task was cancelled
                if (not asTask.isCancelled)
                    # Should the task go to the synchronized queue or the asynchronized queue
                    # The asynchronized task may be executed after pushing it
                    if (asTask.isParallel) then asQueue.push(asTask)
                    else @_asWorkerPool.addTask(asTask)

                # Even if the task was cancelled or not remove it from the queue
                @_asActiveTask.pop()
            else
                break

        # Handle every task deferred to the synchronized channel, those task
        # will be executed on the browser main thread
        while (not asQueue.isEmpty)
            # Run the task popped from the queue
            asTask = asQueue.pop()
            asTask.run()

            if (@isOverloaded)
                asTask.setTime(@_asCurrentTick + asTask.getPriority().getDeferredTime)
            else
                asTask.setTime(@_asCurrentTick)

            # Check if the task is repeatitive
            if (asTask.isRepeating and not asTask.isCancelled)
                @_asDeferredTask.push(asTask)

        # Add every task that was left to add from an external call or
        # a repeatitive task
        while (not @_asDeferredTask.isEmpty)
            @_asActiveTask.push(@_asDeferredTask.pop())

        # A tick just happend
        @_asCurrentTick++
        asDiffTime = @_asTimer.getSystemTime() - asStartTime
        
        # Handle the timing of the loop
        if (asDiffTime <= @_asTimePerTick)
            # remove a counter from the overloaded tick.
            @_asOverloadedTick--

            # Sleep the time between the frame
            setTimeout(@start, @_asTimerPerTick - asDiffTime)
        else
            # Add a counter to the overloaded tick.
            @_asOverloadedTick++

            # Don't sleep since we need to try to catch the tick
            setTimeout(@start, 0)