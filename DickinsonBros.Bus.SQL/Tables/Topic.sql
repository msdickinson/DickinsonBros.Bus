CREATE TABLE [ServiceBus].[Topic]
(
	[TopicId] BIGINT NOT NULL IDENTITY(1,1) CONSTRAINT Topic_PK PRIMARY KEY,
    [TopicToken] uniqueidentifier NOT NULL,
    [UserId] BIGINT NOT NULL CONSTRAINT FK_Topic_UserId REFERENCES [ServiceBus].[User](UserId),
    [Name] VARCHAR(255) NOT NULL,
    [Schema]  VARCHAR(MAX) NOT NULL, 
    [DateAdded] DATETIME2 NOT NULL,
    [DateChanged] DATETIME2 NOT NULL 
)
