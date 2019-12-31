CREATE PROCEDURE [ServiceBus].[UpdateQueue]
	@queueId bigint,
	@userId bigint,
    @state int
AS
	Update [ServiceBus].[Queue]
	SET
		[State] = @state,
		[LastStateChange] = SYSUTCDATETIME() 		
	where QueueId = @queueId AND
		  UserId = @userId

RETURN 0
