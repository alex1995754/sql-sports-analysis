-- Проверка, что в каждой команде по 11 игроков
SELECT team_id, COUNT(*) AS player_count FROM players GROUP BY team_id;

-- Список всех команд
SELECT * FROM teams;

-- Список всех команд по-алфавиту с их игроками
SELECT t.name AS team_name, p.name AS player_name
FROM teams t
JOIN players p ON t.team_id = p.team_id
ORDER BY team_name;

-- Список всех игроков по-алфавиту с их командами
SELECT p.name AS player_name, t.name AS team_name
FROM players p
JOIN teams t ON p.team_id = t.team_id
ORDER BY player_name;

-- Список всех матчей с результатами
SELECT m.match_id, t1.name AS team1, t2.name AS team2, m.date, m.result
FROM matches m
JOIN teams t1 ON m.team_id1 = t1.team_id
JOIN teams t2 ON m.team_id2 = t2.team_id
ORDER BY `date`;

-- Лучшие бомбардиры
SELECT name, goals
FROM players
ORDER BY goals DESC
LIMIT 10;

-- Рейтинг команд по общему количеству забитых голов игроками
SELECT t.name AS team_name, SUM(p.goals) AS total_goals
FROM players p
JOIN teams t ON p.team_id = t.team_id
GROUP BY t.team_id, t.name
ORDER BY total_goals DESC;

-- Матчи, завершившиеся ничьей
SELECT m.match_id, t1.name AS team1, t2.name AS team2, m.date, m.result
FROM matches m
JOIN teams t1 ON m.team_id1 = t1.team_id
JOIN teams t2 ON m.team_id2 = t2.team_id
WHERE SUBSTRING_INDEX(m.result, ':', 1) = SUBSTRING_INDEX(m.result, ':', -1);


