import random
from faker import Faker
import pymysql

# Настройка подключения к базе данных
db = pymysql.connect(
    host="localhost",
    user="root",  # Ваш пользователь
    password="12345",  # Ваш пароль
    database="sportsdata"
)
cursor = db.cursor()
fake = Faker()

# Вставляем данные в teams
teams = []
for _ in range(20):
    name = fake.company()
    city = fake.city()
    founded_year = random.randint(1900, 2010)
    cursor.execute("INSERT INTO teams (name, city, founded_year) VALUES (%s, %s, %s)", (name, city, founded_year))
    teams.append(cursor.lastrowid)

# Вставляем данные в players
positions = ['Forward', 'Midfielder', 'Defender', 'Goalkeeper']
# Циклическое распределение игроков
num_teams = len(teams)
for i in range(220):
    name = fake.name()
    team_id = teams[i % num_teams]  # Циклическое назначение команды
    position = random.choice(positions)
    goals = random.randint(0, 50)
    cursor.execute("INSERT INTO players (name, team_id, position, goals) VALUES (%s, %s, %s, %s)", (name, team_id, position, goals))

# Вставляем данные в matches
for _ in range(36):
    team_id1, team_id2 = random.sample(teams, 2)
    date = fake.date_this_year()
    result = f"{random.randint(0, 5)}:{random.randint(0, 5)}"
    cursor.execute("INSERT INTO matches (team_id1, team_id2, date, result) VALUES (%s, %s, %s, %s)", (team_id1, team_id2, date, result))

# Вставляем данные в statistics
cursor.execute("SELECT player_id FROM players")
players = [row[0] for row in cursor.fetchall()]
cursor.execute("SELECT match_id FROM matches")
matches = [row[0] for row in cursor.fetchall()]

for _ in range(50):
    player_id = random.choice(players)
    match_id = random.choice(matches)
    goals = random.randint(0, 3)
    assists = random.randint(0, 3)
    cursor.execute("INSERT INTO statistics (player_id, match_id, goals, assists) VALUES (%s, %s, %s, %s)", (player_id, match_id, goals, assists))

# Сохраняем изменения и закрываем соединение
db.commit()
cursor.close()
db.close()
