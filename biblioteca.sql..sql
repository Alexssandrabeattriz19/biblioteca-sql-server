
USE biblioteca;
GO

-- CRIANDO AS TABELAS

CREATE TABLE Livro (
    Cod_Livro NUMERIC(7) PRIMARY KEY,
    Titulo CHAR(50),
    Editora CHAR(30),
    Ano NUMERIC(4),
    Local VARCHAR(45)
);

CREATE TABLE Autor (
    Cod_Autor NUMERIC(7) PRIMARY KEY,
    Nome_Autor CHAR(50)
);

CREATE TABLE Livro_Autor (
    Cod_Autor NUMERIC(7) NOT NULL,
    Cod_Livro NUMERIC(7) NOT NULL,
    PRIMARY KEY (Cod_Autor, Cod_Livro)
);

CREATE TABLE Assunto (
    Cod_Assunto NUMERIC(4) PRIMARY KEY,
    Desc_Assunto CHAR(50)
);

CREATE TABLE Livro_Assunto (
    Cod_Livro NUMERIC(7) NOT NULL,
    Cod_Assunto NUMERIC(4) NOT NULL,
    PRIMARY KEY (Cod_Livro, Cod_Assunto)
);

CREATE TABLE Associado (
    Cod_Associado NUMERIC(7) PRIMARY KEY,
    Nome_Associado CHAR(50),
    Endereco CHAR(50),
    Telefone CHAR(15),
    Email CHAR(50),
    Data_Nasc VARCHAR(45)
);

CREATE TABLE Cidade (
    Cod_Cidade INT PRIMARY KEY,
    Nome_Cidade CHAR(30),
    UF VARCHAR(45)
);

CREATE TABLE Dependente (
    Cod_Dependente NUMERIC(7) PRIMARY KEY,
    Cod_Cidade INT,
    Cod_Associado NUMERIC(7),
    Nome_Dependente CHAR(50),
    Data_Nasc VARCHAR(45)
);

CREATE TABLE Exemplar (
    Num_Exemplar NUMERIC(9) PRIMARY KEY,
    Cod_Livro NUMERIC(7),
    Data_Aquisicao DATE
);

-- PK COMPOSTA CORRIGIDA
CREATE TABLE Exemplar_Associado (
    Num_Exemplar NUMERIC(9) NOT NULL,
    Cod_Associado NUMERIC(7) NOT NULL,
    Data_Emprestimo DATE NOT NULL,
    Data_Devolucao VARCHAR(45),
    CONSTRAINT PK_Exemplar_Associado
        PRIMARY KEY (
            Num_Exemplar,
            Cod_Associado,
            Data_Emprestimo
        )
);

CREATE TABLE Multa (
    Cod_Multa NUMERIC(6) PRIMARY KEY,
    Num_Exemplar NUMERIC(9),
    Cod_Associado NUMERIC(7),
    Data_Emprestimo DATE,
    Valor NUMERIC(7,2),
    Data_Pagamento DATE
);

-- CRIANDO OS RELACIONAMENTOS

-- 1. EXEMPLAR -> LIVRO
ALTER TABLE Exemplar
ADD CONSTRAINT FK_Exemplar_Livro
FOREIGN KEY (Cod_Livro)
REFERENCES Livro(Cod_Livro);

-- 2. LIVRO_AUTOR -> AUTOR
ALTER TABLE Livro_Autor
ADD CONSTRAINT FK_Livro_Autor_Autor
FOREIGN KEY (Cod_Autor)
REFERENCES Autor(Cod_Autor);

-- 3. LIVRO_AUTOR -> LIVRO
ALTER TABLE Livro_Autor
ADD CONSTRAINT FK_Livro_Autor_Livro
FOREIGN KEY (Cod_Livro)
REFERENCES Livro(Cod_Livro);

-- 4. LIVRO_ASSUNTO -> ASSUNTO
ALTER TABLE Livro_Assunto
ADD CONSTRAINT FK_Livro_Assunto_Assunto
FOREIGN KEY (Cod_Assunto)
REFERENCES Assunto(Cod_Assunto);

-- 5. LIVRO_ASSUNTO -> LIVRO
ALTER TABLE Livro_Assunto
ADD CONSTRAINT FK_Livro_Assunto_Livro
FOREIGN KEY (Cod_Livro)
REFERENCES Livro(Cod_Livro);

-- 6. DEPENDENTE -> CIDADE
ALTER TABLE Dependente
ADD CONSTRAINT FK_Dependente_Cidade
FOREIGN KEY (Cod_Cidade)
REFERENCES Cidade(Cod_Cidade);

-- 7. DEPENDENTE -> ASSOCIADO
ALTER TABLE Dependente
ADD CONSTRAINT FK_Dependente_Associado
FOREIGN KEY (Cod_Associado)
REFERENCES Associado(Cod_Associado);

-- 8. EXEMPLAR_ASSOCIADO -> EXEMPLAR
ALTER TABLE Exemplar_Associado
ADD CONSTRAINT FK_Exemplar_Associado_Exemplar
FOREIGN KEY (Num_Exemplar)
REFERENCES Exemplar(Num_Exemplar);

-- 9. EXEMPLAR_ASSOCIADO -> ASSOCIADO
ALTER TABLE Exemplar_Associado
ADD CONSTRAINT FK_Exemplar_Associado_Associado
FOREIGN KEY (Cod_Associado)
REFERENCES Associado(Cod_Associado);

-- 10. MULTA -> EXEMPLAR_ASSOCIADO
ALTER TABLE Multa
ADD CONSTRAINT FK_Multa_Exemplar_Associado
FOREIGN KEY (
    Num_Exemplar,
    Cod_Associado,
    Data_Emprestimo
)
REFERENCES Exemplar_Associado (
    Num_Exemplar,
    Cod_Associado,
    Data_Emprestimo
);


USE biblioteca;
GO

ALTER TABLE dbo.Exemplar_Associado
ADD CONSTRAINT UQ_Exemplar_Associado
UNIQUE (
    Num_Exemplar,
    Cod_Associado,
    Data_Emprestimo
);
GO

ALTER TABLE dbo.Multa
ADD CONSTRAINT FK_Multa_Exemplar_Associado
FOREIGN KEY (
    Num_Exemplar,
    Cod_Associado,
    Data_Emprestimo
)
REFERENCES dbo.Exemplar_Associado (
    Num_Exemplar,
    Cod_Associado,
    Data_Emprestimo
);
GO
