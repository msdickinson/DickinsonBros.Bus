CREATE PROCEDURE ServiceBus.QueueStateUpsert
( 
	@queueStateId int,
	@state varchar(50)
)
AS 
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRAN
 
    IF EXISTS ( SELECT * FROM ServiceBus.QueueState WITH (UPDLOCK) WHERE QueueStateId = @queueStateId )
      UPDATE ServiceBus.QueueState
      SET 
         [State] = @state,
         DateChanged = SYSUTCDATETIME()
      WHERE QueueStateId = @queueStateId;
 
    ELSE 
      INSERT ServiceBus.QueueState 
	  (
        QueueStateId,
        [State],
        DateChanged,
        DateCreated
      )
      VALUES
	  (
        @queueStateId,
        @state,
        SYSUTCDATETIME(),
        SYSUTCDATETIME()
      );
 
  COMMIT