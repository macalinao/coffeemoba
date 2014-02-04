##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the base class for any event
#
Common.Event.Event = class Event
    #
    # Default constructor
    #
    constructor : () ->
        @_isCancelled = false

    #
    # Return the name of the event
    #
    getName : () ->
        return "Event"

    #
    # Return if the e
    #
    isCancelled : () ->
        return @_isCancelled

    #
    # Set the cancellation of this event
    #
    # \param m_IsCancelled True if the event is cancelled
    #
    setCancelled : (@_isCancelled = true) ->
        return