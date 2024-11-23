-- Список всех команд
SELECT * 
FROM teams;

-- Список всех команд по-алфавиту с их игроками
SELECT t.name AS team_name, p.name AS player_name
FROM teams t
JOIN players p ON t.team_id = p.team_id
ORDER BY team_name;

-- Проверка, что в каждой команде по 11 игроков (запрос для проверки логики insert_data.py)
SELECT team_id, COUNT(*) AS player_count 
FROM players GROUP BY team_id;



-- Список всех игроков
SELECT * FROM players;

-- Список всех игроков по-алфавиту с их командами
SELECT p.name AS player_name, t.name AS team_name
FROM players p
JOIN teams t ON p.team_id = t.team_id
ORDER BY player_name;

-- Количество игроков в каждой команде:
SELECT t.name AS team_name, COUNT(p.player_id) AS player_count
FROM teams t
LEFT JOIN players p ON t.team_id = p.team_id
GROUP BY t.team_id, t.name
ORDER BY player_count DESC;

-- Таблица с голами игроков за всё время
SELECT player_id, name, sum(goals) AS total_goals 
FROM players
GROUP BY player_id
ORDER BY player_id;

-- Таблица с голами игроков за сезон
SELECT s.player_id, p.name, sum(s.goals) AS total_goals
FROM statistics AS s
JOIN players p ON s.player_id = p.player_id
GROUP BY player_id
ORDER BY player_id;

-- Таблица с голами игроков за всё время и за сезон
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
SELECT * 
FROM matches;

-- Список всех матчей с результатами
SELECT m.match_id, t1.name AS team1, t2.name AS team2, m.date, m.result
FROM matches m
JOIN teams t1 ON m.team_id1 = t1.team_id
JOIN teams t2 ON m.team_id2 = t2.team_id;

-- Общее количество голов за сезон
SELECT SUM(CAST(SUBSTRING_INDEX(result, ':', 1) AS UNSIGNED)) + 
       SUM(CAST(SUBSTRING_INDEX(result, ':', -1) AS UNSIGNED)) AS total_goals
FROM matches;

-- Лучшие бомбардиры
SELECT name, goals
FROM players
ORDER BY goals DESC
LIMIT 10;

-- Рейтинг команд по общему количеству забитых голов игроками
SELECT t.name AS team_name, SUM(p.goals) AS total_goals
FROM players p
JOIN teams t ON p.team_id = t.team_id
GROUP BY t.name
ORDER BY total_goals DESC;

-- Матчи, завершившиеся ничьей
SELECT m.match_id, t1.name AS team1, t2.name AS team2, m.date, m.result
FROM matches m
JOIN teams t1 ON m.team_id1 = t1.team_id
JOIN teams t2 ON m.team_id2 = t2.team_id
WHERE SUBSTRING_INDEX(m.result, ':', 1) = SUBSTRING_INDEX(m.result, ':', -1);

-- Матчи, завершившиеся ничьей в 0
SELECT m.match_id, t1.name AS team1, t2.name AS team2, m.date, m.result
FROM matches m
JOIN teams t1 ON m.team_id1 = t1.team_id
JOIN teams t2 ON m.team_id2 = t2.team_id
WHERE SUBSTRING_INDEX(m.result, ':', 1) = 0
AND   SUBSTRING_INDEX(m.result, ':', -1) = 0;

-- Среднее количество голов за матч:
SELECT AVG(SUBSTRING_INDEX(result, ':', 1) + SUBSTRING_INDEX(result, ':', -1)) AS avg_goals
FROM matches;

-- Игроки с наибольшим количеством голов в одном матче
SELECT s.player_id, p.name, s.match_id, MAX(s.goals) AS max_goals
FROM statistics s
JOIN players p ON s.player_id = p.player_id
GROUP BY s.player_id, s.match_id
ORDER BY max_goals DESC
LIMIT 10;

-- Игроки с наибольшим количеством голов в одном матче и командой
SELECT s.player_id, p.name AS player, t.name AS home_team, s.match_id, MAX(s.goals) AS max_goals
FROM statistics s
JOIN players p ON s.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
GROUP BY s.player_id, s.match_id
ORDER BY max_goals DESC
LIMIT 10;



-- Статистика по всем матчам сезона
SELECT *
FROM statistics;

-- Проверка количества записей в каждой таблице
SELECT 'teams' AS table_name, COUNT(*) AS record_count FROM teams
UNION ALL
SELECT 'players', COUNT(*) FROM players
UNION ALL
SELECT 'matches', COUNT(*) FROM matches
UNION ALL
SELECT 'statistics', COUNT(*) FROM statistics;

-- Проверка наличия игроков без команды (+ проверка логики insert_data.py)
SELECT *
FROM players
WHERE team_id NOT IN (SELECT team_id FROM teams);

-- Команда с максимальным количеством побед
SELECT t.name AS team_name, COUNT(*) AS wins
FROM matches m
JOIN teams t ON (m.team_id1 = t.team_id AND SUBSTRING_INDEX(m.result, ':', 1) > SUBSTRING_INDEX(m.result, ':', -1))
             OR (m.team_id2 = t.team_id AND SUBSTRING_INDEX(m.result, ':', -1) > SUBSTRING_INDEX(m.result, ':', 1))
GROUP BY t.team_id, t.name
ORDER BY wins DESC;

-- Игрок с наибольшим вкладом (голы + ассисты) в матчах
SELECT p.name, SUM(s.goals + s.assists) AS total_contributions
FROM statistics s
JOIN players p ON s.player_id = p.player_id
GROUP BY p.player_id, p.name
ORDER BY total_contributions DESC
LIMIT 1;
