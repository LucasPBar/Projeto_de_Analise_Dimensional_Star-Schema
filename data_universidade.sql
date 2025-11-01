USE universidade;

-- ========== DIM_Professor ==========
INSERT INTO Dim_Professor (idProfessor, nomeProfessor, titulacao, cargo, tempoInstituicao, email) VALUES
(1, 'Mariana Silva', 'Doutora', 'Profª Associada', 8, 'mariana.silva@uni.edu'),
(2, 'Ricardo Alves', 'Mestre', 'Profº Adjunto', 5, 'ricardo.alves@uni.edu'),
(3, 'Fernanda Costa', 'Doutora', 'Profª Titular', 12, 'fernanda.costa@uni.edu'),
(4, 'Paulo Menezes', 'Mestre', 'Professor', 3, 'paulo.menezes@uni.edu'),
(5, 'Ana Rodrigues', 'Especialista', 'Profª Assistente', 2, 'ana.rodrigues@uni.edu'),
(6, 'Gustavo Pereira', 'Doutor', 'Profº Adjunto', 6, 'gustavo.pereira@uni.edu');

-- ========== DIM_Departamento ==========
INSERT INTO Dim_Departamento (idDepartamento, nomeDepartamento, campus, idProfessorCoordenador) VALUES
(10, 'Engenharia de Produção', 'Campus Norte', 3),
(11, 'Ciência da Computação', 'Campus Leste', 1),
(12, 'Administração', 'Campus Sul', 2),
(13, 'Matemática Aplicada', 'Campus Centro', 6);

-- ========== DIM_Curso ==========
INSERT INTO Dim_Curso (idCurso, nomeCurso, nivel, duracao, departamentoVinculado) VALUES
(100, 'Engenharia de Produção', 'Graduação', 10, 'Engenharia de Produção'),
(101, 'Ciência da Computação', 'Graduação', 8, 'Ciência da Computação'),
(102, 'MBA Gestão de Operações', 'Pós', 4, 'Administração'),
(103, 'Análise e Ciência de Dados', 'Pós', 4, 'Ciência da Computação'),
(104, 'Licenciatura em Matemática', 'Graduação', 8, 'Matemática Aplicada'),
(105, 'Extensão em Power BI', 'Extensão', 1, 'Ciência da Computação');

-- ========== DIM_Disciplina ==========
INSERT INTO Dim_Disciplina (idDisciplina, nomeDisciplina, cargaHoraria, modalidade, areaConhecimento) VALUES
(1000, 'Processos de Produção', 60, 'Presencial', 'Produção'),
(1001, 'Pesquisa Operacional', 45, 'Presencial', 'Otimização'),
(1002, 'Algoritmos e Estruturas de Dados', 60, 'Presencial', 'Programação'),
(1003, 'Machine Learning', 60, 'Híbrido', 'Ciência de Dados'),
(1004, 'Gestão de Projetos', 40, 'EAD', 'Gestão'),
(1005, 'Estatística Aplicada', 60, 'Presencial', 'Estatística'),
(1006, 'Cálculo Numérico', 45, 'Presencial', 'Matemática'),
(1007, 'Power BI (Extensão)', 20, 'EAD', 'BI');

-- ========== DIM_TEMPO ==========
-- idData será um surrogate (1..12), dataCompleta em formato DATE
INSERT INTO Dim_Tempo (idData, dataCompleta, ano, semestre, mes, trimestre, diaSemana, tipoEvento) VALUES
(1, '2024-03-01', 2024, 1, 3, 1, 'Sexta-feira', 'inicio_semestre'),
(2, '2024-04-15', 2024, 1, 4, 2, 'Segunda-feira', 'oferta_disciplina'),
(3, '2024-06-01', 2024, 1, 6, 2, 'Sábado', 'fim_semestre'),
(4, '2024-08-20', 2024, 2, 8, 3, 'Terça-feira', 'inicio_semestre'),
(5, '2024-09-10', 2024, 2, 9, 3, 'Quarta-feira', 'oferta_disciplina'),
(6, '2024-11-30', 2024, 2, 11, 4, 'Sábado', 'fim_semestre'),
(7, '2025-01-15', 2025, 1, 1, 1, 'Quarta-feira', 'inicio_semestre'),
(8, '2025-03-10', 2025, 1, 3, 1, 'Segunda-feira', 'oferta_disciplina'),
(9, '2025-05-25', 2025, 1, 5, 2, 'Domingo', 'fim_semestre'),
(10, '2025-08-01', 2025, 2, 8, 3, 'Sexta-feira', 'inicio_semestre'),
(11, '2025-09-05', 2025, 2, 9, 3, 'Sexta-feira', 'oferta_disciplina'),
(12, '2025-11-20', 2025, 2, 11, 4, 'Quinta-feira', 'fim_semestre');

-- ========== FATO: Fato_Professor ==========
-- Granularidade: professor x disciplina x curso x data (uma linha por combinação observada)
INSERT INTO Fato_Professor (idProfessor, idDepartamento, idCurso, idDisciplina, idData, qtdDisciplinasMinistradas, qtdCursosAssociados, qtdDepartamentosVinculados, cargaHorariaTotal) VALUES
-- Mariana Silva (Profª Associada) ministra Processos de Produção e Pesquisa Operacional em 2024-03-01
(1, 10, 100, 1000, 1, 1, 1, 1, 60),
(1, 10, 100, 1001, 2, 1, 1, 1, 45),

-- Ricardo Alves leciona Algoritmos e ML em cursos de Ciência da Computação (registro em tempos diferentes)
(2, 11, 101, 1002, 2, 1, 1, 1, 60),
(2, 11, 103, 1003, 5, 1, 2, 1, 60),

-- Fernanda Costa coordena Engenharia e ministra Gestão de Projetos e Estatística Aplicada
(3, 10, 102, 1004, 4, 1, 1, 1, 40),
(3, 10, 100, 1005, 8, 1, 1, 1, 60),

-- Paulo Menezes dá Power BI (extensão) e Algoritmos (apoio)
(4, 11, 105, 1007, 5, 1, 1, 1, 20),
(4, 11, 101, 1002, 8, 2, 1, 1, 60),

-- Ana Rodrigues (profª assistente) participa como monitora em Estatística e Cálculo Numérico
(5, 13, 104, 1005, 3, 1, 0, 1, 60),
(5, 13, 104, 1006, 6, 1, 0, 1, 45),

-- Gustavo Pereira leciona Machine Learning e Pesquisa Operacional em diferentes ofertas
(6, 11, 103, 1003, 8, 1, 1, 1, 60),
(6, 12, 102, 1001, 10, 1, 1, 1, 45);
