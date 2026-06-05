USE INSTACART_DB;
GO
--Crean login
CREATE LOGIN usr_migrator WITH PASSWORD = 'Migrate2024!';
GO
--Se crea el usuari en la base de datos
CREATE USER usr_migrator FOR LOGIN usr_migrator;
GO

--Se otorga permisos
GRANT SELECT ON SCHEMA::dbo TO usr_migrator;
GRANT VIEW DATABASE STATE TO usr_migrator;

USE INSTACART_DB;
GO
SELECT COUNT(*) FROM order_products;