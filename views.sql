create or replace view DISEASE_VIEW as
SELECT
        dis_name,
        dis_desc
    FROM
        desease
    WHERE
        desease.deleted IS NULL
/

create or replace trigger TRG_DELETE_DISEASE
	instead of delete
	on DISEASE_VIEW
	for each row
DECLARE
    PRAGMA autonomous_transaction;
BEGIN
    UPDATE desease
    SET
        desease.deleted = systimestamp
    WHERE
        desease.dis_name = :old.dis_name;
    COMMIT;
END;
/

create or replace view MEDICINE_VIEW as
SELECT MED_NAME, MED_DESC
  FROM MEDICINE
  WHERE MEDICINE.DELETED is NULL
/

create or replace trigger TRG_DELETE_MEDICINE
	instead of delete
	on MEDICINE_VIEW
	for each row
DECLARE
    PRAGMA autonomous_transaction;
BEGIN
    UPDATE medicine
    SET
        medicine.deleted = systimestamp
    WHERE
        medicine.med_name = :old.med_name;

    COMMIT;
END;
/

create or replace view SYMPTOM_VIEW as
SELECT SYM_NAME, SYM_DESC
  FROM SYMPTOM
  WHERE SYMPTOM.DELETED is NULL
/

create or replace trigger TRG_DELETE_SYMPTOM
	instead of delete
	on SYMPTOM_VIEW
	for each row
DECLARE
    PRAGMA autonomous_transaction;
BEGIN
    UPDATE symptom
    SET
        symptom.deleted = systimestamp
    WHERE
        symptom.sym_name = :old.sym_name;

    COMMIT;
END;
/

create or replace view MDS_VIEW as
SELECT
        mds_date,
        DESEASE_DIS_NAME,
        SYMPTOM_SYM_NAME,
        MEDICINE_MED_NAME
    FROM
        MDS
    WHERE
        MDS.deleted IS NULL
/

