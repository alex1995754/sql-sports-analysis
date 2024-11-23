import os
import subprocess
import sys

# Проверка и установка модулей
required_modules = ['pymysql', 'faker']

# Функция для проверки наличия модуля
def is_module_installed(module_name):
    try:
        __import__(module_name)
        return True
    except ImportError:
        return False

# Проверка всех модулей и составление списка отсутствующих
missing_modules = [module for module in required_modules if not is_module_installed(module)]

if missing_modules:
    print(f"Следующие модули отсутствуют: {', '.join(missing_modules)}.")
    consent = input("Хотите установить их? (y/n): ").strip().lower()
    if consent == 'y':
        print("Устанавливаем модули...")
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', *missing_modules])
        print("Все отсутствующие модули успешно установлены.")
    else:
        print("Необходимые модули не установлены. Завершаем программу.")
        sys.exit(1)

# Импортируем модули после установки
import pymysql
from faker import Faker

# Функция для установки зависимости (на случай, если другой пользователь запустит скрипт)
def install_and_import(module_name):
    try:
        __import__(module_name)
    except ImportError:
        print(f"Устанавливается модуль {module_name}...")
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', module_name])
        print(f"Модуль {module_name} успешно установлен.")

# Убеждаемся, что все зависимости установлены
for module in required_modules:
    install_and_import(module)

# Функция для подключения к базе данных с повторным запросом данных
def connect_to_database():
    while True:
        host = input("Введите хост (например, localhost): ").strip()
        user = input("Введите имя пользователя MySQL: ").strip()
        password = input("Введите пароль MySQL: ").strip()

        try:
            db = pymysql.connect(
                host=host,
                user=user,
                password=password
            )
            print("\nУспешное подключение к MySQL!\n")
            return db
        except Exception as e:
            print(f"Ошибка подключения к MySQL: {e}")
            retry = input("Хотите повторить попытку? (y/n): ").strip().lower()
            if retry != 'y':
                print("Завершаем программу.")
                sys.exit(1)

# Подключение к базе данных
db = connect_to_database()
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
        subprocess.Popen(
            ['start', '', queries_sql_path], shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
    elif os.name == 'posix':  # Для Linux/macOS
        subprocess.Popen(
            ['xdg-open', queries_sql_path], start_new_session=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
    print(f"Файл {queries_sql_path} открыт для просмотра.")
except Exception as e:
    print(f"Не удалось открыть файл {queries_sql_path}: {e}")

# Закрываем соединение
cursor.close()
db.close()

# Финальное сообщение
print("\nПрограмма завершена. Нажмите Enter, чтобы закрыть окно.")
input()