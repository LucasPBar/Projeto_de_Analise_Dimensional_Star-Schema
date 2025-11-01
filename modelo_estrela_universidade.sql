-- drop database universidade;

-- =========================================
-- CRIAÇÃO DO BANCO DE DADOS DIMENSIONAL
-- =========================================
CREATE DATABASE IF NOT EXISTS universidade;
USE universidade;

-- =========================================
-- DIMENSÕES
-- =========================================

-- Dimensão Professor
CREATE TABLE Dim_Professor (
    idProfessor INT PRIMARY KEY,
    nomeProfessor VARCHAR(100),
    titulacao VARCHAR(50),
    cargo VARCHAR(50),
    tempoInstituicao INT,
    email VARCHAR(100)
);

-- Dimensão Departamento
CREATE TABLE Dim_Departamento (
    idDepartamento INT PRIMARY KEY,
    nomeDepartamento VARCHAR(100),
    campus VARCHAR(100),
    idProfessorCoordenador INT
);

-- Dimensão Curso
CREATE TABLE Dim_Curso (
    idCurso INT PRIMARY KEY,
    nomeCurso VARCHAR(100),
    nivel VARCHAR(50),              -- Ex: Graduação, Pós, Extensão
    duracao INT,                    -- Duração em semestres
    departamentoVinculado VARCHAR(100)
);

-- Dimensão Disciplina
CREATE TABLE Dim_Disciplina (
    idDisciplina INT PRIMARY KEY,
    nomeDisciplina VARCHAR(100),
    cargaHoraria INT,
    modalidade VARCHAR(50),         -- Presencial, EAD, Híbrido
    areaConhecimento VARCHAR(100)
);

-- Dimensão Tempo
CREATE TABLE Dim_Tempo (
    idData INT PRIMARY KEY,
    dataCompleta DATE,
    ano INT,
    semestre INT,
    mes INT,
    trimestre INT,
    diaSemana VARCHAR(15),
    tipoEvento VARCHAR(50)          -- Ex: oferta_disciplina, início_curso, fim_semestre
);

-- =========================================
-- TABELA FATO (Foco: Professor)
-- =========================================
CREATE TABLE Fato_Professor (
    idFatoProfessor INT AUTO_INCREMENT PRIMARY KEY,
    idProfessor INT,
    idDepartamento INT,
    idCurso INT,
    idDisciplina INT,
    idData INT,
    
    -- Medidas (fatos quantitativos)
    qtdDisciplinasMinistradas INT,
    qtdCursosAssociados INT,
    qtdDepartamentosVinculados INT,
    cargaHorariaTotal INT,
    
    -- Definição das relações
    CONSTRAINT fk_professor FOREIGN KEY (idProfessor) REFERENCES Dim_Professor(idProfessor),
    CONSTRAINT fk_departamento FOREIGN KEY (idDepartamento) REFERENCES Dim_Departamento(idDepartamento),
    CONSTRAINT fk_curso FOREIGN KEY (idCurso) REFERENCES Dim_Curso(idCurso),
    CONSTRAINT fk_disciplina FOREIGN KEY (idDisciplina) REFERENCES Dim_Disciplina(idDisciplina),
    CONSTRAINT fk_data FOREIGN KEY (idData) REFERENCES Dim_Tempo(idData)
);
