##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

############################################
# ENUMERATION
############################################
EventPriority =
	# Priority: 0 -> Can be cancelled
	Lowest  : 0

	# Priority: 1 -> Can be cancelled
	Low     : 100

	# Priority: 2 -> Can be cancelled
	Normal  : 200

	# Priority: 3 -> Can be cancelled
	High    : 300

	# Priority: 4 -> Can be cancelled
	Highest : 400

	# Priority: 5 -> Can be cancelled
	Monitor : 500

############################################
# CLASS
############################################
class Event
	#
	# Default constructor
	#
	constructor: () -> 
		@_isCancelled = false

	#
	# Return the name of the event
	#
	getName: () -> 
		return "Event"

	#
	# Return if the event is cancelled
	#
	isCancelled: () -> 
		return @_isCancelled

	#
	# Set the cancellation of this event
	#
	# \param m_IsCancelled True if the event is cancelled
	#
	setCancelled: (@_isCancelled = true) ->
		return

############################################
# CLASS
############################################
class HandlerList
	#
	# Default constructor of the class
	#
	constructor: -> @_asEventList = []

	#
	# Calls an event into all delegates
	#
	# \param asEvent The event to be propagated
	#
	emitEvent: (asEvent) ->
		for asListener in @_asEventList.slice(0).reverse()
			# Only execute it if the event is not cancelled or the listener can be
			# execute even if the event was cancelled
			if (asEvent.isCancelled() is false || asListener.ignoreCancelled)
				asListener.callback(asEvent)
		return

	#
	# Register a new event into the list
	#
	# \param asListener The listener to register
	# \param asPriority The priority of the listener
	# \param ignoreCancelled True if the function cancels if the event is cancelled
	#
	addEvent: (asListener, asPriority, ignoreCancelled) ->
		# Convert to a tuple
		asTuple  = {callback: asListener, priority: asPriority, ignoreCancelled: ignoreCancelled}

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
	removeEvent: (asListener, asPriority) ->
		# Find the event to remove it
		for asNode, asIndex in @_asEventList
			if (asNode.callback == asListener && asNode.priority == asPriority)
					@_asEventList.splice(asIndex, 1)
					return true
		return false

	#
	# Return if the handler contains any event
	#
	hasEvents: -> 
		return !!@_asEventList.length