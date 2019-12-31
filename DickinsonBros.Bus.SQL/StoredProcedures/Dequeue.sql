CREATE PROCEDURE [ServiceBus].[Dequeue]
	@userId bigint,
    @count int
AS
	WITH cte_queueItems AS (
		SELECT top(@count)
			[ServiceBus].[Queue].QueueId, 
			[ServiceBus].[TopicItem].TopicId,
			[ServiceBus].[TopicItem].Payload
		FROM
			[ServiceBus].[Queue]
			inner join [ServiceBus].[TopicItem] on [ServiceBus].[TopicItem].TopicId = [ServiceBus].[Queue].TopicId
		WHERE 
			[ServiceBus].[Queue].UserId = @userId and 
			[ServiceBus].[Queue].[State] = 1 and
			[ServiceBus].[Queue].[RetryCount] <= 4
	)
	Update [ServiceBus].[Queue]
	SET
		[State] = 2,
		[LastStateChange] = SYSUTCDATETIME() 		
	OUTPUT cte_queueItems.QueueId, cte_queueItems.TopicId, cte_queueItems.Payload
	FROM [ServiceBus].[Queue]
	INNER JOIN cte_queueItems on [ServiceBus].[Queue].QueueId = cte_queueItems.QueueId
RETURN 0
