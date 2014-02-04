##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# <<https://github.com/xk/node-threads-a-gogo>>
#
Threading = require('threads_a_gogo')

#
# Define the implementation of #{Common.TaskWorker}
#
Server.TaskWorker = class TaskWorker extends Common.TaskWorker
    #
    # Default constructor
    #
    # \param _asWorkerCount The number of workers
    #
    constructor : (@_asWorkerCount) ->
        @_asWorkerPool = Threading.createPool(@_asWorkerCount)

    #
    # Destroy the worker pool
    #
    destroy : ->
        @_asWorkerPool.destroy()

    #
    # Add task into the worker pool
    #
    # \param asTask The task to be added to the pool
    #
    addTask : (asTask) ->
        @_asWorkerPool.eval(asTask.run)