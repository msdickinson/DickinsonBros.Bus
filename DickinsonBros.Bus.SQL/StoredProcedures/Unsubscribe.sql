CREATE PROCEDURE [ServiceBus].[Unsubscribe]
	@userId BIGINT,
	@topicId BIGINT
AS
	IF (SELECT COUNT(*) FROM [ServiceBus].[Subscription] WHERE [UserId] = @userId AND [TopicId] = @topicId) = 0
		THROW 51000, 'The subscription does not exist.', 1;
	ELSE
		DELETE 
		from [ServiceBus].[Subscription]
		where 
			[UserID] = @userId and 
			[TopicId] = @topicId	
RETURN 0