##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

############################################
# CLASS
############################################
class EventManager
	#
	# Default constructor
	#
	# \param asTaskManager The task manager of this manager
	#
	constructor: (asTaskManager) ->
		# The instance of the task manager
		@_asTaskManager = asTaskManager

		# The list of every event in this manager
		@_asEventList   = []

	#
	# Emit an event into every observer and execute
	# a completation handler at the end
	#
	# \param asEvent    The event to be emited
	# \param asFunction The completation handler
	#
	# \return The event that was triggered
	#
	emitEvent: (asEvent, asFunction = null) ->
		# Retrieve the type handler
		asHandler = @_asEventList[asEvent.getName()]

		# Emit the event to every handler
		if asHandler  isnt null then asHandler.emitEvent(asEvent)
		if asFunction isnt null then asFunction(asEvent)
		return asEvent
		
	#
	# Emit an event into every observer asynchronized
	# and execute a completation handler at the end
	#
	# \param asEvent The event to be emited
	# \param asFunction The completation handler
	#
	# \return This instance
	#
	emitEventAsync: (asEvent, asFunction = null) ->
		# Push a work into any available task
		# to pickup the event and execute it
		@_asTaskManager.addTask => @emitEvent(asEvent, asFunction)
		return @

	#
	# Add an event into the engine
	#
	# \param asType     The type of the event
	# \param asListener The listener to register
	# \param asPriority The priority of the listener
	# \param ignoreCancelled True if the listener can be cancelled
	#
	# \return This instance
	#
	addEvent: (asType, asListener, asPriority = EventPriority.Normal, ignoreCancelled = false) ->
		if (asType is null || asListener is null)
			throw EventException("Unable to register an nulled event.")

		# Add the listener to the list.
		# If the handler is empty, then create a new instance
		(@_asEventList[asType] ?= new HandlerList).addEvent(asListener, asPriority, ignoreCancelled)
		return @

	#
	# Removes an event from the engine
	#
	# \param asType     The type of the event
	# \param asListener The listener to register
	# \param asPriority The priority of the listener
	#
	# \return This instance
	#
	removeEvent: (asType, asListener, asPriority = EventPriority.Normal) ->
		if (asType is null || asListener is null || @_asEventList[asType] is null)
			throw EventException("Unable to register an nulled event.")

		# Forward the call to the targer HandlerList
		@_asEventList[asType].removeEvent(asListener, asPriority)
		return @

	#
	# Removes every event registered
	#
	# \param asType The type of the event or null to remove everything
	#
	# \return This instance
	#
	removeAllEvent: (asType) ->
		# If the optional parameter is set then remove
		# only the event specified, otherwise remove every event
		# registered by this context
		if asType is null then delete @_asEventList else delete @_asEventList[asType]
		return @