-- auto-generated definition
create table MDS
(
  MDS_DATE          DATE         not null
    constraint MDS_PK
      primary key,
  DESEASE_DIS_NAME  VARCHAR2(30) not null
    constraint MDS_DESEASE_FK
      references DESEASE
    constraint DESEASE_DIS_NAME_CHECK
      check ( REGEXP_LIKE(desease_dis_name,
                          '^[0-9A-Z_a-z]{1,30}$') ),
  SYMPTOM_SYM_NAME  VARCHAR2(30) not null
    constraint MDS_SYMPTOM_FK
      references SYMPTOM
    constraint SYMPTOM_SYM_NAME_CHECK
      check ( REGEXP_LIKE(symptom_sym_name,
                          '^[0-9A-Z_a-z]{1,30}$') ),
  MEDICINE_MED_NAME VARCHAR2(30) not null
    constraint MDS_MEDICINE_FK
      references MEDICINE
    constraint MEDICINE_MED_NAME_CHECK
      check ( REGEXP_LIKE(medicine_med_name,
                          '^[0-9A-Z_a-z]{1,30}$') ),
  DELETED           DATE default NULL
)
/

