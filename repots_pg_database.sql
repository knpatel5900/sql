-- Table: public.account_report_lead

-- DROP TABLE IF EXISTS public.account_report_lead;

CREATE TABLE IF NOT EXISTS public.account_report_lead
(
    "Id" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    date date,
    open_accounts integer,
    closed_accounts integer,
    CONSTRAINT account_report_lead_pkey PRIMARY KEY ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.account_report_lead
    OWNER to savadmin;

REVOKE ALL ON TABLE public.account_report_lead FROM quicksight;

GRANT SELECT ON TABLE public.account_report_lead TO quicksight;

GRANT ALL ON TABLE public.account_report_lead TO savadmin;


--Create Sequence

-- SEQUENCE: public.account_report_lead_Id_seq

-- DROP SEQUENCE IF EXISTS public."account_report_lead_Id_seq";

CREATE SEQUENCE IF NOT EXISTS public."account_report_lead_Id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."account_report_lead_Id_seq"
    OWNER TO savadmin;