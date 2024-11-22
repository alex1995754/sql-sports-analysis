import os
import pymysql
import subprocess

# Настройка подключения к базе данных
db = pymysql.connect(
    host="localhost",
    user="root",  # Замените на вашего пользователя MySQL
    password="12345"  # Замените на ваш пароль MySQL
)
cursor = db.cursor()

# Пути к файлам
create_tables_path = os.path.join("sql_scripts", "create_tables.sql")
insert_data_script = os.path.join("python_scripts", "insert_data.py")
queries_sql_path = os.path.join("sql_scripts", "queries.sql")  # Путь к queries.sql

# Шаг 1: Выполнение create_tables.sql
try:
    with open(create_tables_path, "r", encoding="utf-8") as file:  # Указываем кодировку UTF-8
        sql_script = file.read()
        for statement in sql_script.split(';'):
            if statement.strip():  # Выполняем только непустые команды
                cursor.execute(statement)
        print("База данных и таблицы успешно созданы.")
except Exception as e:
    print(f"Ошибка при выполнении SQL-скрипта: {e}")

# Шаг 2: Запуск insert_data.py
try:
    print("Заполняем таблицы данными...")
    os.system(f"python {insert_data_script}")
    print("Данные успешно добавлены.")
except Exception as e:
    print(f"Ошибка при выполнении insert_data.py: {e}")

# Шаг 3: Открытие файла queries.sql с помощью стандартной программы
try:
    if os.name == 'nt':  # Для Windows
        os.startfile(queries_sql_path)
    elif os.name == 'posix':  # Для Linux/macOS
        subprocess.run(['xdg-open', queries_sql_path])  # Для Linux
    print(f"Файл {queries_sql_path} открыт для просмотра.")
except Exception as e:
    print(f"Не удалось открыть файл {queries_sql_path}: {e}")

# Закрываем соединение
cursor.close()
db.close()