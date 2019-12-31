CREATE PROCEDURE [ServiceBus].[Subscribe]
	@userId BIGINT,
	@topicId BIGINT
AS
	IF (SELECT COUNT(*) FROM [ServiceBus].[Subscription] WHERE [UserId] = @userId AND [TopicId] = @topicId) >= 1
		THROW 51000, 'The subscription already exist.', 1;
	ELSE
		INSERT INTO [ServiceBus].[Subscription]
		(
			UserId,
			TopicId,
			DateCreated
		)
		VALUES
		(
			@userId,
			@topicId,
			SYSUTCDATETIME()
		)
RETURN 0
