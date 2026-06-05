 CREATE DATABASE LINK sqlserver_link
    CONNECT TO "usr_migrator" IDENTIFIED BY "Migrate2024!"
    USING 'SQLSERVER_INSTACART';

-- Verificar que el DBLink funciona
SELECT * FROM "dbo"."aisles"@sqlserver_link WHERE ROWNUM = 1;
