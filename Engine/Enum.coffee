##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Define a Java-style enumeration
#
class Enum
    # Define the lenght of the enumeration
    @_asLenght : 0
    
    # Define the values of the enumeration
    @_asValues : {}

    #
    # Return a clone copy of the enumeration values
    #
    @getValues : ->
        asValues = new Array()
        for asValue in Object.keys(@_asValues)
            asValues.push(@_asValues[asValue])
        return asValues

    #
    # Return the value of a enumeration by its name
    #
    @valueOf : (asName) ->
        return @_asValues[asName]

    #
    # Default constructor of the enumeration
    #
    constructor : ->
        asClass = @getSuperclass()
        
        @_asName = Object.keys(asClass._asValues)[asClass._asLenght]
        @_asOrdinal = asClass._asLenght

        asClass._asLenght++
        asClass._asValues[@_asName] = @

    #
    # Return the name of the enumeration
    #
    getName : ->
        return @_asName

    #
    # Return the ordinal value of the enumeration
    #
    getOrdinal: ->
        return @_asOrdinal

    #
    # Return the class of this enumeration
    #
    getClass: ->
        return @constructor

    #
    # Return the super class of this enumeration
    #
    getSuperClass: ->
        return @getClass().__super__.constructor

    #
    # Compare this enumeration with another enumeration
    #
    # \param asEnumeration The other enumeration
    #
    compareTo: (asEnumeration) ->
        return @_asOrdinal - asEnumeration._asOrdinal

    #
    # Return if the enumeration given is same than this enumeration
    #
    equals: (asEnumeration) ->
        return @ is asEnumeration

    #
    # Returns a string representation of the enumeration
    #
    toString: ->
        return "#{@_asName} (#{@_asOrdinal})"