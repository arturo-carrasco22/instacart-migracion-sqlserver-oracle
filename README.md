# Migración de Base de Datos Transaccional — Proyecto Instacart
# SQL Server 2022 → Oracle 19c | +32 millones de registros

> Proyecto académico

---

## Descripción

Migración completa de la base de datos del dataset público de Instacart (Kaggle) desde SQL Server 2022 hacia Oracle 19c, sobre infraestructura virtualizada con VirtualBox. El proceso incluyó configuración de red entre VMs, carga masiva de CSVs, arquitectura CDB/PDB en Oracle, tablespaces segmentados, DBLink entre motores heterogéneos y transferencia por lotes de más de 32 millones de registros.

---

## Arquitectura

PC Host (Windows)
├── INST-SQL2022  →  192.168.10.10  |  SQL Server 2022  |  4 GB RAM
└── INST-ORA19C  →  192.168.10.20  |  Oracle 19c        |  6 GB RAM
         ↑
    Red Interna VirtualBox (intnet-instacart)
    Puerto SQL Server: 1433
    Puerto Oracle Listener: 1521

**Flujo de migración:**

CSVs Kaggle → BULK INSERT → SQL Server (INSTACART_DB)
                                    ↓
                              DBLink (SQLSERVER_INSTACART)
                                    ↓
                         Oracle 19c (CDB: INSTACART / PDB: PDBORDERS)
---

## Tecnologías

| Herramienta | Versión | Uso |
|---|---|---|
| Oracle VirtualBox | 7.x | Virtualización de ambos servidores |
| SQL Server | 2022 | Base de datos origen |
| Oracle Database | 19c (19.3.0.0) | Base de datos destino |
| SQL Server Management Studio | 19 | Administración SQL Server |
| SQL*Plus | 19.3 | Administración Oracle |
| Windows Server | 2019 | SO de ambas VMs |

---

## Estructura del repositorio

├── README.md
├── SQLServer/
│   ├── 01_create_database.sql       -- Crea INSTACART_DB con filegroups
│   ├── 02_create_tables.sql         -- DDL de las 5 tablas (esquema dbo)
│   ├── 03_bulk_insert.sql           -- Carga de CSVs con BULK INSERT
│   └── 04_create_user.sql           -- Usuario usr_migrator con mínimo privilegio
├── Oracle/
│   ├── 01_create_tablespaces.sql    -- tbsInstacart (datos) + tbsIndex (índices)
│   ├── 02_create_user.sql           -- USR_MIGRATOR con quotas y privilegios
│   ├── 03_create_tables.sql         -- DDL de las 5 tablas en PDBORDERS
│   ├── 04_create_dblink.sql         -- DBLink hacia SQL Server via HS
│   └── 05_migrate_data.sql          -- INSERT via DBLink + lotes para 32M filas
├── Configuracion/
│   ├── listener.ora                 -- Configuración del listener Oracle
│   └── tnsnames.ora                 -- Entradas de red Oracle (INSTACART, pdbOrders)
└── docs/
    └── IMPORTACION_DE_BASE.pdf      -- Evidencia del proceso con capturas

---

## Dataset

**Fuente:** [Instacart Market Basket Analysis — Kaggle](https://www.kaggle.com/datasets/snegii/instacart-dataset)

| Tabla | Filas migradas |
|---|---|
| aisles | 134 |
| departments | 21 |
| products | 49,688 |
| orders | 3,421,083 |
| order_products | 32,931,847 |
| **TOTAL** | **~36.4 millones** |

> `order_products` unifica `order_products__prior.csv` y `order_products__train.csv` del dataset original.

---

## Pasos del proceso

### 1. Infraestructura
- Importar OVA del profesor dos veces en VirtualBox
- Asignar IPs estáticas en red interna (`intnet-instacart`)
- Verificar conectividad con ping entre VMs (firewall activo)
- Abrir puerto 1433 con regla de entrada en Windows Defender

### 2. SQL Server — carga de datos
- Instalar SQL Server 2022 Developer + SSMS en INST-SQL2022
- Habilitar TCP/IP en puerto 1433 via SQL Server Configuration Manager
- Crear base de datos `INSTACART_DB` con filegroups en `C:\INSTACART\`
- Crear 5 tablas en esquema `dbo`
- Cargar CSVs con `BULK INSERT` en orden de dependencia (tablas pequeñas primero)
- Crear usuario `usr_migrator` con solo `SELECT` sobre el esquema

### 3. Oracle — configuración
- Instalar Oracle 19c en INST-ORA19C usando el ZIP del profesor
- Crear PDB `PDBORDERS` dentro del CDB `INSTACART` via DBCA
- Multiplexar control files (3 copias en discos C, FRA e I)
- Crear tablespaces `tbsInstacart` (G:) y `tbsIndex` (I:)
- Crear usuario `USR_MIGRATOR` con quotas ilimitadas en ambos tablespaces
- Configurar `listener.ora` y `tnsnames.ora`
- Instalar SQL*Plus en INST-SQL2022 + configurar `tnsnames.ora` local

### 4. Migración
- Crear DBLink `SQLSERVER_LINK` apuntando a `SQLSERVER_INSTACART` (HS)
- Transferir tablas pequeñas con `INSERT INTO ... SELECT * FROM ...@sqlserver_link`
- Transferir `order_products` (32M filas) por lotes de 100k `order_id` con `EXECUTE IMMEDIATE` para evitar errores de UNDO tablespace

---

## Desafíos técnicos resueltos

**Conectividad entre VMs:** el firewall de Windows bloqueaba los pings por defecto. Se resolvió habilitando reglas ICMP via `netsh` sin desactivar el firewall completamente.

**BULK INSERT en products.csv:** los nombres de productos contienen comas internas. Se resolvió con el flag `FIELDQUOTE='"'` en el `WITH` del BULK INSERT.

**Inconsistencia de control files:** al agregar un tercer control file en disco I:, Oracle detectó versiones distintas al reiniciar. Se resolvió con `SHUTDOWN IMMEDIATE` + `STARTUP` luego de actualizar el parámetro `control_files`.

**Migración de 32M filas via DBLink:** un INSERT directo agota el UNDO tablespace y cae la sesión. Se resolvió con un bloque PL/SQL que itera por rangos de `order_id` usando SQL dinámico (`EXECUTE IMMEDIATE`) con commits parciales cada 100k IDs.

---

## Habilidades técnicas aplicadas

- Oracle 19c (CDB/PDB, Tablespaces, DBLink, Heterogeneous Services)
- SQL Server 2022 (BULK INSERT, T-SQL, SQL Server Configuration Manager)
- PL/SQL (bloques anónimos, SQL dinámico, manejo de errores)
- Migración de datos ETL básico entre motores heterogéneos
- Virtualización con Oracle VirtualBox
- Seguridad por principio de mínimo privilegio

---

## Notas

- Los archivos CSV del dataset no están incluidos en el repositorio. Descargar desde el link de Kaggle indicado arriba.
- Las contraseñas en los scripts son de entorno académico local. Reemplazar en producción.
- Este proyecto fue desarrollado con apoyo de herramientas de IA para consultas técnicas y documentación.
