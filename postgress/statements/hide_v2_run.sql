/*   -------------------------------------hiding sv2 statements------------------------
	UPDATE eidmadm.docmaster
		SET    docflags = 1
		       ,revisioncomments = 'Lead Prod Hide' 
		WHERE docid in ( SELECT docid FROM eidmadm.DOCTBL_Account_Doc WHERE fld_intakeid = '7b8b801e-97b9-46e1-b3fa-bb9fd32b7fc1')
			 	
	UPDATE eidmadm.docmaster
		SET    docflags = 1
		       ,revisioncomments = 'Lead Prod Hide' 
		WHERE docid in (SELECT docid FROM eidmadm.DOCTBL_Customer_Doc WHERE fld_intakeid = '7b8b801e-97b9-46e1-b3fa-bb9fd32b7fc1')
*/