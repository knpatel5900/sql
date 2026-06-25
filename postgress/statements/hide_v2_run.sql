
/*  SELECT ITEMS */

select docid, doccreatedate, doccreateduserid, docflags, doctitle,revisioncomments
	from eidmadm.docmaster (nolock)
	where (docid in
		(select docid
		from eidmadm.DOCTBL_Customer_Doc (nolock)
		where FLD_IntakeId in ('5c0a3761-6a71-4047-80c0-e4b49d3cd3d6')
)
		or docid in
		(select docid
		from eidmadm.DOCTBL_Account_Doc (nolock)
		where FLD_IntakeId in ('5c0a3761-6a71-4047-80c0-e4b49d3cd3d6')
)
)

update eidmadm.docmaster
set docflags = 1,revisioncomments = 'SD-21934 TPB - Prod - Please hide statements from run on 6/3'	
where docid in
	(select docid
	from eidmadm.docmaster (nolock)
	where docflags = 0
		and (docid in
		(select docid
		from eidmadm.DOCTBL_Customer_Doc (nolock)
		where FLD_IntakeId in ('5c0a3761-6a71-4047-80c0-e4b49d3cd3d6')
)
		or docid in
		(select docid
		from eidmadm.DOCTBL_Account_Doc (nolock)
		where FLD_IntakeId in ('5c0a3761-6a71-4047-80c0-e4b49d3cd3d6')
)))