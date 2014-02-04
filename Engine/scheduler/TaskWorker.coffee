##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the interface for a worker implementation
#
Common.TaskWorker = class TaskWorker
    #
    # Destroy the worker pool
    #
    destroy : ->
        throw Error "Unimplemented method"

    #
    # Add task into the worker pool
    #
    # \param asTask The task to be added to the pool
    #
    addTask : (asTask) ->
        throw Error "Unimplemented method"