CREATE TABLE SNF_TEST.HH_Estimation_ClientUsage(CLIENTREADERACCOUNTNAME STRING,
    TABLE_NAME STRING,
    CUSTOMERID STRING,
    CLIENT_ROWS NUMBER,
    TOTAL_ROWS NUMBER,
    CLIENT_RATIO NUMBER(14,6),
    CLIENT_TABLE_GB_USAGE NUMBER(14,6),
    PRIMARY KEY (CLIENTREADERACCOUNTNAME, TABLE_NAME, CUSTOMERID)
)
CLUSTER BY (TABLE_NAME,CLIENTREADERACCOUNTNAME,CUSTOMERID);



SELECT * FROM SNF_TEST.VW_SNF_TABLE_SIZES;


// Check data in this table for final output

SELECT * FROM SNF_TEST.HH_Estimation_ClientUsage;


CREATE OR REPLACE PROCEDURE Procedure_HH_ClientEstimation(TABLE_NAME STRING)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    SQL_CMD STRING;
BEGIN
    SQL_CMD := '
    INSERT INTO SNF_TEST.HH_Estimation_ClientUsage
    WITH client_rows AS (
        SELECT
            whcustomerid AS customerid,
            COUNT(*) AS client_rows
        FROM
            MX_PRD.SNF_ODS_SECURE.' || TABLE_NAME || '
        GROUP BY
            whcustomerid
    ),
    total_rows AS (

        SELECT 
            ROW_COUNT AS total_rows 
        FROM 
            SNOWFLAKE.ACCOUNT_USAGE.tables 
        WHERE 
            TABLE_CATALOG = ''MX_PRD'' 
            AND TABLE_SCHEMA = ''SNF_ODS_SECURE'' 
            AND TABLE_OWNER = ''ROLE_MX_PRD_OWNER'' 
            AND lower(TABLE_NAME) = lower(''' || TABLE_NAME || ''')
    )
    SELECT DISTINCT
        ClientAdmin.CLIENTREADERACCOUNTNAME,
        ''' || TABLE_NAME || ''' AS TABLE_NAME,
        ClientAdmin.customerindexid AS customerid,
        COALESCE(client_rows.client_rows, 0) AS client_rows,
        total_rows.total_rows,
        COALESCE(client_rows.client_rows * 1.0 / total_rows.total_rows, 0) AS client_ratio,
        (COALESCE(client_rows.client_rows * 1.0 / total_rows.total_rows, 0) * Table_size.Active_GigaBytes_used) AS client_table_GB_usage
    FROM
        MX_PRD.SNF_ODS_SECURE.MYDATACLIENTADMINTABLE AS ClientAdmin
        LEFT JOIN client_rows ON ClientAdmin.customerindexid = client_rows.customerid
        CROSS JOIN total_rows
        JOIN MX_PRD.SNF_TEST.VW_SNF_TABLE_SIZES AS Table_size 
        ON lower(Table_size.TABLE_NAME) = lower(''' || TABLE_NAME || ''')
    WHERE ClientAdmin.CLIENTREADERACCOUNTLOCATOR <> ''ELB63648'' AND
    UPPER(ClientAdmin.CLIENTREADERACCOUNTNAME) IN (''PHEALTH'', ''AAHCC'', ''ROCKYMC'')
        AND ClientAdmin.customerindexid IN (''18618'', ''6768'', ''51446'')
        AND NOT EXISTS (
            SELECT 1 
            FROM SNF_TEST.HH_Estimation_ClientUsage
            WHERE CLIENTREADERACCOUNTNAME = ClientAdmin.CLIENTREADERACCOUNTNAME
            AND TABLE_NAME = ''' || TABLE_NAME || '''
            AND CUSTOMERID = ClientAdmin.customerindexid
            );';
    
    EXECUTE IMMEDIATE SQL_CMD;
    RETURN 'Processed table ' || TABLE_NAME;
END;
$$;



------------------------------------------



DECLARE
  c1 CURSOR FOR SELECT DISTINCT TABLE_NAME FROM MX_PRD.SNF_TEST.SNF_TableList; 
  TblName string;
BEGIN
  FOR record IN c1 DO
    TblName := record.TABLE_NAME;
    CALL MX_PRD.SNF_TEST.Procedure_HH_ClientEstimation(:TblName);
  END FOR;
  RETURN 'Client data inserted!';
END;