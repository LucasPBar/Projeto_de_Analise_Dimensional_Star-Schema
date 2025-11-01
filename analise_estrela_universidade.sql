-- Q1: Top professores por carga horária total (soma da cargaHorariaTotal no fato)
SELECT p.nomeProfessor,
       SUM(f.cargaHorariaTotal) AS carga_total_horas,
       COUNT(DISTINCT f.idDisciplina) AS disciplinas_distintas
FROM Fato_Professor f
JOIN Dim_Professor p ON p.idProfessor = f.idProfessor
GROUP BY p.idProfessor, p.nomeProfessor
ORDER BY carga_total_horas DESC;

-- Q2: Quantas disciplinas cada professor ministrou (granularidade: professor)
SELECT p.nomeProfessor,
       COUNT(DISTINCT f.idDisciplina) AS qtd_disciplinas,
       COUNT(DISTINCT f.idCurso) AS qtd_cursos
FROM Fato_Professor f
JOIN Dim_Professor p ON p.idProfessor = f.idProfessor
GROUP BY p.idProfessor, p.nomeProfessor
ORDER BY qtd_disciplinas DESC, qtd_cursos DESC;

-- Q3: Distribuição de carga horária por departamento por semestre/ano
SELECT d.nomeDepartamento, t.ano, t.semestre, SUM(f.cargaHorariaTotal) AS carga_horas
FROM Fato_Professor f
JOIN Dim_Departamento d ON d.idDepartamento = f.idDepartamento
JOIN Dim_Tempo t ON t.idData = f.idData
GROUP BY d.nomeDepartamento, t.ano, t.semestre
ORDER BY t.ano, t.semestre, carga_horas DESC;

-- Q4: Atuação por curso - quais professores lecionaram em cada curso
SELECT c.nomeCurso, p.nomeProfessor, COUNT(*) AS vezes_registrado
FROM Fato_Professor f
JOIN Dim_Curso c ON c.idCurso = f.idCurso
JOIN Dim_Professor p ON p.idProfessor = f.idProfessor
GROUP BY c.idCurso, c.nomeCurso, p.idProfessor, p.nomeProfessor
ORDER BY c.nomeCurso, vezes_registrado DESC;

-- Q5: Séries temporais - número de disciplinas ofertadas por semestre (usando Dim_Tempo)
SELECT t.ano, t.semestre, COUNT(DISTINCT f.idDisciplina) AS disciplinas_ofertadas
FROM Fato_Professor f
JOIN Dim_Tempo t ON t.idData = f.idData
GROUP BY t.ano, t.semestre
ORDER BY t.ano, t.semestre;

-- Q6: Professores coordenadores de departamentos (lista)
SELECT p.nomeProfessor, d.nomeDepartamento
FROM Dim_Departamento d
LEFT JOIN Dim_Professor p ON p.idProfessor = d.idProfessorCoordenador
WHERE d.idProfessorCoordenador IS NOT NULL;

-- Q7: Carga horária média por disciplina (com nome da disciplina)
SELECT di.nomeDisciplina, AVG(f.cargaHorariaTotal) AS carga_media_por_linha
FROM Fato_Professor f
JOIN Dim_Disciplina di ON di.idDisciplina = f.idDisciplina
GROUP BY di.idDisciplina, di.nomeDisciplina
ORDER BY carga_media_por_linha DESC;

-- Q8: Buscar histórico de um professor (timeline de disciplinas e cursos)
-- Exemplo: trocar a idProfessor por outro valor se quiser.
SELECT p.nomeProfessor, t.dataCompleta, c.nomeCurso, di.nomeDisciplina, f.cargaHorariaTotal, t.tipoEvento
FROM Fato_Professor f
JOIN Dim_Professor p ON p.idProfessor = f.idProfessor
JOIN Dim_Tempo t ON t.idData = f.idData
JOIN Dim_Curso c ON c.idCurso = f.idCurso
JOIN Dim_Disciplina di ON di.idDisciplina = f.idDisciplina
WHERE p.idProfessor = 2
ORDER BY t.dataCompleta;
