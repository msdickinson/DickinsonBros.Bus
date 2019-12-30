CREATE PROCEDURE [ServiceBus].[InsertTopic]
	@userId bigint,
    @name VARCHAR(255),
    @schema VARCHAR(max)
AS
	insert into [ServiceBus].[Topic]
	(
		TopicToken,
		UserId,
		[Name],
		[Schema],
		DateAdded,
		DateChanged
	)
	OUTPUT INSERTED.TopicId, INSERTED.TopicToken
	VALUES
	(
		NEWID(),
		@userId,
		@name,
		@schema,
		SYSUTCDATETIME(),
		SYSUTCDATETIME()
	);
	
RETURN 0