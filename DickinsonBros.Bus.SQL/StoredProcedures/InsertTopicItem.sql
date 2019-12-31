CREATE PROCEDURE [ServiceBus].[InsertTopicItem]
	@topicToken UNIQUEIDENTIFIER,
	@userId  BIGINT,
    @payload VARCHAR(max)
AS

BEGIN TRANSACTION;  

	DECLARE @currentDateTime AS datetime2(7) = SYSUTCDATETIME();

	--Get Topic Id, And Throw If Not Found
	DECLARE @topicIdResult bigInt;

	set @topicIdResult = (select TopicId 
	FROM [ServiceBus].[Topic]
	WHERE [TopicToken] = @topicToken and
	      UserId = @userId)

	IF @topicIdResult IS NULL
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
		@topicIdResult,
		@payload,
		@currentDateTime
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
		@currentDateTime,
		@currentDateTime
	FROM Subscription
	where Subscription.TopicId = @topicIdResult

	--Return topic item id, and queue count inserted into for diagnostic purposes
	select
		(select TopicItemId from @InsertTopicItemResult) as TopicItemId,
		@@ROWCOUNT as TotalQueuesInsertedInto

COMMIT; 

RETURN 0
