DECLARE @Userid INT;
DECLARE @Username varchar(max);
DECLARE @record varchar(max);
SET @Userid =  (select userid from eidmadm.users where username like '%proxy_%')
SET @Username =  (select username from eidmadm.users where username like '%proxy_%')
SET @record  =(select userid from eidmadm.userxadminmodulesecurity  where moduleid=6 and userid =  @Userid )
PRINT 'UserID: ' + CAST(@UserId AS VARCHAR) 
      + ', Username: ' + @Username 
      + ', Record: ' + CAST(@record AS VARCHAR);
IF @record IS NULL 
Begin
PRINT 'Inserting record in [userxadminmodulesecurity]'
--INSERT INTO [eidmadm].[userxadminmodulesecurity] (userid ,moduleid,owneruserid, createddate, lastmodifieduserid, lastmodifieddate, AllowAdd, AllowModify, AllowDelete, AllowElevation) VALUES (@Userid,6,1,getdate(),1, getdate(), 1, 1, 0, 0)
End
ELSE
BEGIN
   PRINT 'Record already Exists in [userxadminmodulesecurity]'
END
