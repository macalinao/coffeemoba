##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define a singleton access to the entire common engine
#
class EngineAPI
    #
    # Set the engine the singleton
    #
    # \param asEngine The engine of the singleton
    #
    @setEngine : (asEngine) ->
        @_asEngine = asEngine

    #
    # Return the engine of the instance
    #
    @asEngine : ->
        return @_asEngine

    #
    # Return the event manager of the engine
    #
    @asEventManager : ->
        return @_asEngine.getEventManager()
 
    #
    # Return the task manager of the engine
    #
    @asTaskManager : ->
        return @_asEngine.getTaskManager()