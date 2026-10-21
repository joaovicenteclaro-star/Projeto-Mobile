IF DB_ID(N'TaskFlowDB') IS NULL
BEGIN
    CREATE DATABASE TaskFlowDB;
END;
GO

USE TaskFlowDB;
GO

IF OBJECT_ID(N'dbo.Tarefas', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tarefas
    (
        Id INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Tarefas PRIMARY KEY,

        Titulo NVARCHAR(200) NOT NULL,

        Concluida BIT NOT NULL
            CONSTRAINT DF_Tarefas_Concluida DEFAULT (0),

        Prioridade NVARCHAR(10) NOT NULL
            CONSTRAINT DF_Tarefas_Prioridade DEFAULT ('media'),

        DataVencimento DATETIME2 NULL,

        CONSTRAINT CK_Tarefas_Prioridade
            CHECK (Prioridade IN ('baixa', 'media', 'alta')),

        CONSTRAINT CK_Tarefas_Titulo
            CHECK (LEN(LTRIM(RTRIM(Titulo))) > 0)
    );
END;
GO
