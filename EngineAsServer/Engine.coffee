##################################################################
# This file is subject to the terms and conditions defined in    #
# file 'LICENSE.txt', which is part of this source code package. #
##################################################################

#
# Entry of the NodeJS's application
#
exports.Entry = ->
	# Read the configuration file
    if (process.argv.length isnt 3)
        console.log("Usage: Server <config.yml>.")
        console.log("If the file does not exist, a sample will be created.")
        return
    
    # Read the configuration file from the storage
    try
        fileData = Filesystem.readFileSync(process.argv[2], 'utf-8')
    catch asException
        
        # Only if the file wasn't able to read it
        if (asException.code != 'ENOENT')
            console.log("Error: Unable to read the configuration file.")
            throw asException
            
        # Try to create the sample file
        template = Path.join(Path.dirname(Filesystem.realpathSync(__filename)),
            '../Resource/server.yml')
        sample   = Filesystem.readFileSync(template, 'utf-8')
        
        # Write the configuration file to the storage
        try
            Filesystem.writeFileSync(process.argv[2], sample, 'utf-8')
        catch asSecondaryException
            console.log("Error: Unable to write the configuration file.")
            throw asSecondaryException
        
        # The file was created
        console.log("The sample configuration was created.")
        console.log("Please edit the file, then run the same command again.")
        return
    
    # Parse the file using YML
    try
        asSetting = Yaml.load(fileData)
    catch asException
        console.log("Error: Unable to parse the content of the configuration file.")
        throw asException

    #
    # Creates the instance of the global singleton
    #
    Common.EngineAPI.setEngine(new Server.Engine(asSetting))
    Common.EngineAPI.asEngine.initialize()
    Common.EngineAPI.asEngine.start()
    return

#
# Define the implementation of #{Common.Engine}
#
Server.Engine = class Engine extends Common.Engine
    #
    # Default constructor of the engine
    #
    # \param asConfiguration The configuration instance
    #
    constructor : (asConfiguration) ->
        #
        # Creates the instance of the task manager
        #
        asIterationPerSecond = asConfiguration['Engine']['IterationPerSecond']
        asTaskWorker  = new Server.TaskWorker(System.cpus.length)
        asTaskTimer   = new Server.Timer()
        asTaskManager = new Common.TaskManager(asIterationPerSecond, asTaskWorker, asTaskTimer)

        #
        # Creates the instance of the event manager
        #
        asEventManager = new Common.EventManager(asTaskManager)

        #
        # Deferred the call to the super class
        #
        super(asEventManager, asTaskManager, asConfiguration)