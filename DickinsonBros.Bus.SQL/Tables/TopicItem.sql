CREATE TABLE [ServiceBus].[TopicItem]
(
	[TopicItemId] BIGINT NOT NULL IDENTITY(1,1) CONSTRAINT TopicItem_PK PRIMARY KEY, 
    [TopicId] VARCHAR(255) NOT NULL,
    [Payload]  VARCHAR(max) NOT NULL,
    [DateCreated] DATETIME2 NOT NULL
)
