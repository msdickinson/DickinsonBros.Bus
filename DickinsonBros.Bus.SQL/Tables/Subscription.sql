CREATE TABLE [ServiceBus].[Subscription]
(
	[SubscriberId] BIGINT NOT NULL IDENTITY(1,1) CONSTRAINT Subscription_PK PRIMARY KEY, 
    [UserId] bigint NOT NULL CONSTRAINT FK_Subscription_UserId REFERENCES [ServiceBus].[User]([UserId]),
    [TopicId] BIGINT NOT NULL CONSTRAINT FK_Subscription_TopicId REFERENCES [ServiceBus].[Topic](TopicId),
    [DateCreated] DATETIME2 NOT NULL
)
