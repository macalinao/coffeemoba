##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the engine to access every module
#
class Engine
    #
    # Default constructor of the engine
    #
    # \param _asEventManager  The event manager implementation
    # \param _asTaskManager   The task manager implementation
    # \param _asConfiguration The configuration instance
    #
    constructor : (@_asEventManager, @_asTaskManager, @_asConfiguration) ->

    #
    # Returns the version of the engine
    #
    getVersion : ->
        return "Helium v0.000.01 (Codename: Rabbit)"

    #
    # Returns the configuration of the engine
    #
    getConfiguration : ->
        return @_asConfiguration

    #
    # Returns the event manager of this engine
    #
    getEventManager : ->
        return @_asEventManager

    #
    # Returns the scheduler of this engine
    #
    getTaskManager : ->
        return @_asTaskManager