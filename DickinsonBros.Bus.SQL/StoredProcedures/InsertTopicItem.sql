CREATE PROCEDURE [ServiceBus].[InsertTopicItem]
	@topicToken UNIQUEIDENTIFIER,
	@userId  BIGINT,
    @payload VARCHAR(max)
AS

BEGIN TRANSACTION;  

	--Get Topic Id, And Throw If Not Found
	DECLARE @topicIdResult TABLE  
	(  
		TopicId bigInt
	);  

	INSERT INTO @topicIdResult (TopicId)
	SELECT TopicId 
	FROM [ServiceBus].[Topic]
	WHERE [TopicToken] = @topicToken and
	      UserId = @userId

	IF (SELECT count(*) FROM @topicIdResult ) = 0
		THROW 51000, 'The Topic does not exist.', 1; 

	--Insert Topic Item
	DECLARE @InsertTopicItemResult TABLE  
	(  
		TopicItemId bigInt
	);  

	insert into [ServiceBus].[TopicItem]
	(
		TopicId,
		Payload,
		DateCreated
	)
	OUTPUT INSERTED.TopicItemId into @InsertTopicItemResult
	VALUES
	(
		(select TopicId from @topicIdResult),
		@payload,
		SYSUTCDATETIME()
	)

	--Insert Into into queue for each subscriber
	INSERT INTO [ServiceBus].[Queue] 
	(
		UserId,
		TopicId,
		TopicItemId,
		[State],
		RetryCount,
		LastStateChange,
		DateCreated
	)
	SELECT 
		UserId,
		Subscription.TopicId,
		(select TopicItemId from @InsertTopicItemResult),
		1,
		0,
		SYSUTCDATETIME(),
		SYSUTCDATETIME()
	FROM Subscription
	inner join @topicIdResult as topicIdResult on Subscription.TopicId = topicIdResult.TopicId

	--Return topic item id, and queue count inserted into for diagnostic purposes
	select
		(select TopicItemId from @InsertTopicItemResult) as TopicItemId,
		@@ROWCOUNT as TotalQueuesInsertedInto

COMMIT; 

RETURN 0
