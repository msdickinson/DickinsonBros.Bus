CREATE PROCEDURE [ServiceBus].[DeleteUser]
	@token UNIQUEIDENTIFIER
AS
	IF (SELECT COUNT(*) FROM [ServiceBus].[User] WHERE [UserToken] = @token) = 0
		THROW 51000, 'The User does not exist.', 1;
	ELSE
		DELETE FROM [ServiceBus].[User] WHERE [UserToken] = @token
	
RETURN 0
