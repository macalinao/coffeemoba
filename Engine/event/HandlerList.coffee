##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the handler for a specified event
#
class HandlerList
    #
    # Default constructor of the class
    #
    constructor : -> @_asEventList = []

    #
    # Calls an event into all delegates
    #
    # \param asEvent The event to be propagated
    #
    emitEvent : (asEvent) ->
        for asListener in @_asEventList by -1
            # Only execute it if the event is not cancelled or the listener
            # can be execute even if the event was cancelled
            if (asEvent.isCancelled() is false or asListener.ignoreCancelled)
                asListener.callback(asEvent)
        return

    #
    # Register a new event into the list
    #
    # \param asListener The listener to register
    # \param asPriority The priority of the listener
    # \param ignoreCancelled Does the listener excecutes always?
    #
    addEvent : (asListener, asPriority, ignoreCancelled) ->
        # Convert to a tuple
        asTuple  =
            callback : asListener
            priority : asPriority
            ignoreCancelled : ignoreCancelled

        # Add the event into a priority list to handle
        # it correctly
        for asNode, asIndex in @_asEventList
            if (asPriority > asNode.priority)
                @_asEventList.splice(asIndex, 0, asTuple)
                return

        # Add it to the tail of the list
        @_asEventList.push(asTuple)
        return

    #
    # Unregister an event from the list
    #
    # \param asListener The listener to unregister
    # \param asPriority The priority of the listener
    #
    # \return True if the event was removed
    #
    removeEvent : (asListener, asPriority) ->
        # Find the event to remove it
        for asNode, asIndex in @_asEventList
            if (asNode.callback is asListener and asNode.priority is asPriority)
                @_asEventList.splice(asIndex, 1)
                return true
        return false

    #
    # Return if the handler contains any event
    #
    hasEvents : ->
        return !!@_asEventList.length