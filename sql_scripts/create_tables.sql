DROP DATABASE IF EXISTS sportsdata;
CREATE SCHEMA sportsdata;
USE sportsdata;

-- Удаляем таблицы в правильном порядке
DROP TABLE IF EXISTS `statistics`;
DROP TABLE IF EXISTS `matches`;
DROP TABLE IF EXISTS `players`;
DROP TABLE IF EXISTS `teams`;

-- Таблица команд
CREATE TABLE `teams` (
  `team_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `city` varchar(50),
  `founded_year` int,
  PRIMARY KEY (`team_id`)
);

-- Таблица игроков
CREATE TABLE `players` (
  `player_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `team_id` bigint unsigned NOT NULL,
  `position` varchar(20) NOT NULL,
  `goals` int DEFAULT 0,
  PRIMARY KEY (`player_id`),
  CONSTRAINT `fk_players_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`) ON DELETE CASCADE
);

-- Таблица матчей
CREATE TABLE `matches` (
  `match_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `team_id1` bigint unsigned NOT NULL,
  `team_id2` bigint unsigned NOT NULL,
  `date` date NOT NULL,
  `result` varchar(20) NOT NULL,
  PRIMARY KEY (`match_id`),
  CONSTRAINT `fk_matches_ibfk_1` FOREIGN KEY (`team_id1`) REFERENCES `teams` (`team_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_matches_ibfk_2` FOREIGN KEY (`team_id2`) REFERENCES `teams` (`team_id`) ON DELETE CASCADE
);

-- Таблица статистики
CREATE TABLE `statistics` (
  `stat_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `player_id` bigint unsigned NOT NULL,
  `match_id` bigint unsigned NOT NULL,
  `goals` int DEFAULT 0,
  `assists` int DEFAULT 0,
  PRIMARY KEY (`stat_id`),
  CONSTRAINT `fk_statistics_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_statistics_ibfk_2` FOREIGN KEY (`match_id`) REFERENCES `matches` (`match_id`) ON DELETE CASCADE
);