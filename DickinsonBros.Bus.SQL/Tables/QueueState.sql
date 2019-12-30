CREATE TABLE [ServiceBus].[QueueState]
(
	[QueueStateId] INT NOT NULL IDENTITY(1,1) CONSTRAINT QueueState_PK PRIMARY KEY,   
    [State] VARCHAR(50) NOT NULL,
    [DateCreated] DATETIME2 NOT NULL, 
    [DateChanged] DATETIME2 NOT NULL 
)
