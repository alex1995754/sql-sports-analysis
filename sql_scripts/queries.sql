-- Проверка, что в каждой команде по 11 игроков
SELECT team_id, COUNT(*) AS player_count 
FROM players GROUP BY team_id;

-- Список всех команд
SELECT * 
FROM teams;

-- Список всех команд по-алфавиту с их игроками
SELECT t.name AS team_name, p.name AS player_name
FROM teams t
JOIN players p ON t.team_id = p.team_id
ORDER BY team_name;

-- Список всех игроков
SELECT * FROM players;

-- Список всех игроков по-алфавиту с их командами
SELECT p.name AS player_name, t.name AS team_name
FROM players p
JOIN teams t ON p.team_id = t.team_id
ORDER BY player_name;

-- Таблица с голами игроков за всё время
SELECT player_id, name, sum(goals) AS total_goals 
FROM players
GROUP BY player_id
ORDER BY player_id;

-- Таблица с голами игроков за период
SELECT s.player_id, p.name, sum(s.goals) AS total_goals
FROM statistics AS s
JOIN players p ON s.player_id = p.player_id
GROUP BY player_id
ORDER BY player_id;

-- Таблица с голами игроков за всё время и за период
SELECT 
    p.player_id,
    p.name,
    p.total_goals AS total_goals_all_time,
    s.total_goals AS total_goals_period
FROM 
    (SELECT player_id, name, SUM(goals) AS total_goals 
     FROM players 
     GROUP BY player_id) p
LEFT JOIN 
    (SELECT player_id, SUM(goals) AS total_goals 
     FROM statistics 
     GROUP BY player_id) s
ON 
    p.player_id = s.player_id
ORDER BY 
    p.player_id;

-- Список матчей
SELECT * FROM matches;

-- Список всех матчей с результатами
SELECT m.match_id, t1.name AS team1, t2.name AS team2, m.date, m.result
FROM matches m
JOIN teams t1 ON m.team_id1 = t1.team_id
JOIN teams t2 ON m.team_id2 = t2.team_id;

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


