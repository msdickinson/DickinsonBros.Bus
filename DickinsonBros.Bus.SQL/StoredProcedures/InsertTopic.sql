CREATE PROCEDURE [ServiceBus].[InsertTopic]
	@userId bigint,
    @name VARCHAR(255),
    @schema VARCHAR(max)
AS

DECLARE @currentDateTime AS datetime2(7) = SYSUTCDATETIME()

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
		@currentDateTime,
		@currentDateTime
	);
	
RETURN 0