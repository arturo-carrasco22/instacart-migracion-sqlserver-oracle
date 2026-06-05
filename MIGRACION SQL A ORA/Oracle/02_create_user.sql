-- Ejecutar conectado a PDBORDERS como sysdba

CREATE USER usr_migrator IDENTIFIED BY "Migrate2024!"
    DEFAULT TABLESPACE tbsInstacart
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON tbsInstacart
    QUOTA UNLIMITED ON tbsIndex;

-- Otorgar privilegios minimos necesarios
GRANT CREATE SESSION        TO usr_migrator;
GRANT CREATE TABLE          TO usr_migrator;
GRANT CREATE SEQUENCE       TO usr_migrator;
GRANT CREATE TRIGGER        TO usr_migrator;
GRANT CREATE DATABASE LINK  TO usr_migrator;
GRANT SELECT ANY TABLE      TO usr_migrator;

-- Verificar usuario creado
SELECT username, default_tablespace, account_status
FROM dba_users
WHERE username = 'USR_MIGRATOR';
