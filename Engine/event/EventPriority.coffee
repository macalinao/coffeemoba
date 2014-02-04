##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define the possible priorities of an event
#
Common.EventPriority = class EventPriority extends Common.Enum
    # Enumeration size
    @_asSize   : 0

    # Enumeration values
    @_asValues : { LOWEST, LOW, NORMAL, HIGH, HIGHEST, MONITOR }

    # Priority: 0 -> Can be cancelled
    @LOWEST  : new EventPriority

    # Priority: 1 -> Can be cancelled
    @LOW     : new EventPriority
    
    # Priority: 2 -> Can be cancelled
    @NORMAL  : new EventPriority
    
    # Priority: 3 -> Can be cancelled
    @HIGH    : new EventPriority
    
    # Priority: 4 -> Can be cancelled
    @HIGHEST : new EventPriority
    
    # Priority: 5 -> Can be cancelled
    @MONITOR : new EventPriority