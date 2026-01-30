declare @batchnumber nvarchar(50) = '8f28ff71-3ec8-4c70-a06c-879f415134af'
	,@comment nvarchar(1000) = 'SD-Test - Hide Statements'


/*  SELECT ITEMS */

select docid, doccreatedate, doccreateduserid, docflags, doctitle
	from eidmadm.docmaster (nolock)
	where (docid in
		(select docid 
		from eidmadm.DOCTBL_Customer_Doc (nolock) 
		where FLD_IntakeId = @batchnumber)
		or docid in
		(select docid 
		from eidmadm.DOCTBL_Account_Doc (nolock) 
		where FLD_IntakeId = @batchnumber))


/* DELETE ITEMS */

--update eidmadm.docmaster
--set docflags = 1
--	,revisioncomments = @comment
--where docid in
--	(select docid
--	from eidmadm.docmaster (nolock)
--	where docflags = 0
--		and (docid in
--		(select docid 
--		from eidmadm.DOCTBL_Customer_Doc (nolock) 
--		where FLD_IntakeId = @batchnumber)
--		or docid in
--		(select docid 
--		from eidmadm.DOCTBL_Account_Doc (nolock) 
--		where FLD_IntakeId = @batchnumber)))


/* UN-DELETE ITEMS */

--update eidmadm.docmaster
--set docflags = 0
--	,revisioncomments = ''
--where docid in
--	(select docid
--	from eidmadm.docmaster (nolock)
--	where docflags = 1
--		and (docid in
--		(select docid 
--		from eidmadm.DOCTBL_Customer_Doc (nolock) 
--		where FLD_IntakeId = @batchnumber)
--		or docid in
--		(select docid 
--		from eidmadm.DOCTBL_Account_Doc (nolock) 
--		where FLD_IntakeId = @batchnumber)))