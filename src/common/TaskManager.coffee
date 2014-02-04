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
    #
    construcctor : (@_asIterationPerSecond, @_asWorkerPool) ->
        @_isActive     = false

    #
    # Executes the scheduler
    #
    run : ->
        # Active the scheduler
        @_isActive = true

        # Run while the task manager is active;
        # Every call is a step into the future
        loop
            stepAnAction()
            break if @_isActive is false

        # Clean everything nicelly
        @_asWorkerPool.destroy()
        return

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
        return @_isOverloaded

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
    # Schedules a repeatitive synchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    # \param asDelay    The delayed tick to execute the task
    # \param asPeriod   The repeatitive period tick of the task
    #
    # \return The instance of the task
    #
    addRepeatitiveTask : (asCallback, asPriority, asDelay, asPeriod) ->
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
    # Schedules a repeatitive asynchronized task
    #
    # \param asCallback The callback of the task
    # \param asPriority The priority of the task
    # \param asDelay    The delayed tick to execute the task
    # \param asPeriod   The repeatitive period tick of the task
    #
    # \return The instance of the task
    #
    addAsyncRepeatitiveTask : (asCallback, asPriority, asDelay, asPeriod) ->
        # Deferred the registration of the task
        # to the registrator
        return @deferredTask(asCallback, asPriority, asDelay, asPeriod, true)
    
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
        # A new task has been deferred to be executed
        @_asTaskID++
        
        # Build a new task with the current tick
        # of the scheduler
        asTask = new Task(asCallback, asPriority, @_asCurrentTick + asDelay, asPeriod, isParallel)
        asTask.setName("Task #{@_asTaskID}")

        # Deferred the task to be added when the scheduler
        # finalize it's tick time
        @_asDeferredTask.push(asTask)
        return asTask

    #
    # Step an action in the task manager
    #
    stepAnAction : ->
        # <TODO: The whole task loop>