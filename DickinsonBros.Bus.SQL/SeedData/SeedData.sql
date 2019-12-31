
BEGIN TRANSACTION InsertSeedData;
	DECLARE @CurrentDateTime AS datetime2(7) = SYSUTCDATETIME()

	-- QueueState
	SET IDENTITY_INSERT [ServiceBus].[QueueState] ON
	
	EXEC [ServiceBus].[QueueStateUpsert]
			@queueStateId = 1,
			@state = 'Added',
			@dateChanged = @CurrentDateTime

	EXEC [ServiceBus].[QueueStateUpsert]
			@queueStateId = 2,
			@state = 'Pulled',
			@dateChanged = @CurrentDateTime

	EXEC [ServiceBus].[QueueStateUpsert]
			@queueStateId = 3,
			@state = 'Failed',
			@dateChanged = @CurrentDateTime

	EXEC [ServiceBus].[QueueStateUpsert]
			@queueStateId = 4,
			@state = 'Successful',
			@dateChanged = @CurrentDateTime

	Delete 
	From [ServiceBus].[QueueState]
	Where queueStateId Not In (1,2,3,4)

	SET IDENTITY_INSERT [ServiceBus].[QueueState]  OFF



	-- User
	if(select count(*) from [ServiceBus].[User] where [Name] = 'AccountService') = 0
		EXEC [ServiceBus].[InsertUser]
			@name = 'AccountService'

	DECLARE @AccountServiceUserId AS bigint = (select UserId from [ServiceBus].[User] where [Name] = 'AccountService')
	
	if(select count(*) from [ServiceBus].[User] where [Name] = 'CoasterService') = 0
		EXEC [ServiceBus].[InsertUser]
			@name = 'CoasterService'

	DECLARE @CoasterServiceUserId AS bigint = (select UserId from [ServiceBus].[User] where [Name] = 'CoasterService')
	
	if(select count(*) from [ServiceBus].[User] where [Name] = 'AchievementService') = 0
		EXEC [ServiceBus].[InsertUser]
			@name = 'AchievementService'

	DECLARE @AchievementServiceUserId AS bigint = (select UserId from [ServiceBus].[User] where [Name] = 'AchievementService')
	
	if(select count(*) from [ServiceBus].[User] where [Name] = 'ReportingService') = 0
		EXEC [ServiceBus].[InsertUser]
			@name = 'ReportingService'
	
	DECLARE @ReportingServiceUserId AS bigint = (select UserId from [ServiceBus].[User] where [Name] = 'ReportingService')
	


	-- Topic
	if(select count(*) from [ServiceBus].[Topic] where [Name] = 'CreatedAccount') = 0
	EXEC [ServiceBus].[InsertTopic]
		@userId = @AccountServiceUserId,
		@name = 'CreatedAccount',
		@schema = '{}'

	DECLARE @CreatedAccountTopicId AS bigint = (select TopicId from [ServiceBus].[Topic] where [Name] = 'CreatedAccount')

	if(select count(*) from [ServiceBus].[Topic] where [Name] = 'UpdatedCoaster') = 0
	EXEC [ServiceBus].[InsertTopic]
		@userId = @CoasterServiceUserId,
		@name = 'UpdatedCoaster',
		@schema = '{}'

	DECLARE @UpdatedCoasterTopicId AS bigint = (select TopicId from [ServiceBus].[Topic] where [Name] = 'UpdatedCoaster')

	if(select count(*) from [ServiceBus].[Topic] where [Name] = 'ObtainedAchievement') = 0
	EXEC [ServiceBus].[InsertTopic]
		@userId = @AchievementServiceUserId,
		@name = 'ObtainedAchievement',
		@schema = '{}'

	DECLARE @ObtainedAchievementTopicId AS bigint = (select TopicId from [ServiceBus].[Topic] where [Name] = 'ObtainedAchievement')



	-- Subscription
	if(select count(*) from [ServiceBus].[Subscription] where UserId = @CoasterServiceUserId and TopicId = @CreatedAccountTopicId) = 0
	EXEC [ServiceBus].[Subscribe]
		@userId = @CoasterServiceUserId,
		@topicId = @CreatedAccountTopicId

	if(select count(*) from [ServiceBus].[Subscription] where UserId = @AchievementServiceUserId and TopicId = @CreatedAccountTopicId) = 0
	EXEC [ServiceBus].[Subscribe]
		@userId = @AchievementServiceUserId,
		@topicId = @CreatedAccountTopicId

	if(select count(*) from [ServiceBus].[Subscription] where UserId = @ReportingServiceUserId and TopicId = @CreatedAccountTopicId) = 0
	EXEC [ServiceBus].[Subscribe]
		@userId = @ReportingServiceUserId,
		@topicId = @CreatedAccountTopicId

	if(select count(*) from [ServiceBus].[Subscription] where UserId = @AchievementServiceUserId and TopicId = @UpdatedCoasterTopicId) = 0
	EXEC [ServiceBus].[Subscribe]
		@userId = @AchievementServiceUserId,
		@topicId = @UpdatedCoasterTopicId

	if(select count(*) from [ServiceBus].[Subscription] where UserId = @ReportingServiceUserId and TopicId = @UpdatedCoasterTopicId) = 0
	EXEC [ServiceBus].[Subscribe]
		@userId = @ReportingServiceUserId,
		@topicId = @UpdatedCoasterTopicId

	if(select count(*) from [ServiceBus].[Subscription] where UserId = @ReportingServiceUserId and TopicId = @ObtainedAchievementTopicId) = 0
	EXEC [ServiceBus].[Subscribe]
		@userId = @ReportingServiceUserId,
		@topicId = @ObtainedAchievementTopicId

COMMIT;

--