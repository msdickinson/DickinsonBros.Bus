CREATE PROCEDURE [ServiceBus].[InsertUser]
AS
	insert into [ServiceBus].[User]
	(
		UserToken,
		DateCreated
	)
	OUTPUT INSERTED.UserId, INSERTED.UserToken, INSERTED.DateCreated
	VALUES
	(
		NEWID(),
		SYSUTCDATETIME()
	)
RETURN 0
