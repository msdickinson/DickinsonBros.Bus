SET IDENTITY_INSERT [ServiceBus].[QueueState]  ON


EXEC [ServiceBus].[QueueStateUpsert]
		@queueStateId = 1,
		@state = 'Added'
GO

EXEC [ServiceBus].[QueueStateUpsert]
		@queueStateId = 2,
		@state = 'Pulled'
go

EXEC [ServiceBus].[QueueStateUpsert]
		@queueStateId = 3,
		@state = 'Failed'
go

EXEC [ServiceBus].[QueueStateUpsert]
		@queueStateId = 4,
		@state = 'Succesful'
go

Delete 
From [ServiceBus].[QueueState]
Where queueStateId Not In (1,2,3,4)

SET IDENTITY_INSERT [ServiceBus].[QueueState]  OFF