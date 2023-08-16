
CREATE PROCEDURE kp_getsavusers
AS
BEGIN
    select * from eidmadm.users
END;

EXEC kp_getsavusers