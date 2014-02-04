##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define a singleton access to the entire common engine
#
Common.EngineAPI = class EngineAPI
    #
    # Retrieve the instance of the singleton
    #
    @getInstance : ->
        if (not @_asInstance?)
            @_asInstance = new @
        return @_asInstance

    #
    # Set the engine the singleton
    #
    # \param asEngine The engine of the singleton
    #
    @setEngine : (asEngine) ->
        getInstance()._asEngine = asEngine

    #
    # Return the engine of the instance
    #
    @asEngine : ->
        return getInstance()._asEngine

    #
    # Return the event manager of the engine
    #
    @asEventManager : ->
        return getInstance()._asEngine.getEventManager()

    #
    # Return the task manager of the engine
    #
    @asTaskManager : ->
        return getInstance()._asEngine.getTaskManager()