﻿CREATE TABLE [ServiceBus].[User]
(
	[UserId] BIGINT NOT NULL IDENTITY(1,1) CONSTRAINT User_PK PRIMARY KEY,
    [UserToken] UNIQUEIDENTIFIER NOT NULL, 
    [DateCreated] DATETIME2 NOT NULL 
)


