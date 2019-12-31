CREATE PROCEDURE [ServiceBus].[InsertUser]
	@name varchar(255) 
AS
	insert into [ServiceBus].[User]
	(
		[Name],
		UserToken,
		DateCreated
	)
	OUTPUT INSERTED.UserId, INSERTED.UserToken, INSERTED.DateCreated
	VALUES
	(
		@name,
		NEWID(),
		SYSUTCDATETIME()
	)
RETURN 0
