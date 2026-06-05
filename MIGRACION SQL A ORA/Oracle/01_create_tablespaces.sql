-- Abrir la PDB
ALTER PLUGGABLE DATABASE PDBORDERS OPEN;

-- Conectar a la PDB                        
CONNECT sys/Admin2024!@PDBORDERS as sysdba;
  
-- Tablespace principal para datos
CREATE TABLESPACE tbsInstacart
    DATAFILE 'G:\INSTACART\tablespaces\tbsInstacart01.dbf'
    SIZE 100M
    AUTOEXTEND ON NEXT 50M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE
    SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para indices
CREATE TABLESPACE tbsIndex
    DATAFILE 'I:\INSTACART\tablespaces\tbsIndex01.dbf'
    SIZE 50M
    AUTOEXTEND ON NEXT 10M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE
    SEGMENT SPACE MANAGEMENT AUTO;

-- Verificar tablespaces creados
SELECT tablespace_name, status, block_size
FROM dba_tablespaces
WHERE tablespace_name IN ('TBSINSTACART', 'TBSINDEX');
