CREATE TABLE [ServiceBus].[Queue]
(
	[QueueId] bigint NOT NULL IDENTITY(1,1) CONSTRAINT Queue_PK PRIMARY KEY,
	[UserId] bigint NOT NULL CONSTRAINT FK_Queue_UserId REFERENCES [ServiceBus].[User]([UserId]),
	[TopicId] bigint NOT NULL CONSTRAINT FK_Queue_TopicId REFERENCES [ServiceBus].[Topic]([TopicId]),
	[TopicItemId] bigint NOT NULL CONSTRAINT FK_Queue_TopicItemId REFERENCES [ServiceBus].[TopicItem]([TopicItemId]),
	[State] int NOT NULL CONSTRAINT FK_Queue_State REFERENCES [ServiceBus].[QueueState]([QueueStateId]),
	[RetryCount] int NOT NULL,
	[LastStateChange] datetime2(7) NOT NULL,
	[DateCreated] datetime2(7) NOT NULL
)
