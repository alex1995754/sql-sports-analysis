# SQL Sports Analysis

**SQL Sports Analysis** — это проект для демонстрации навыков работы с базами данных и Python. Он включает SQL-скрипт для создания структуры базы данных, Python-скрипт для наполнения базы данных тестовыми данными, а также примеры SQL-запросов для анализа данных.

## Структура проекта

- **`sql_scripts/create_tables.sql`**  
  SQL-скрипт для создания базы данных и её таблиц. Он создаёт следующие таблицы:
  - `teams` — команды.
  - `players` — игроки.
  - `matches` — матчи.
  - `statistics` — статистика.

- **`python_scripts/insert_data.py`**  
  Python-скрипт для заполнения базы данных тестовыми данными с использованием библиотеки Faker. Наполняет таблицы `teams`, `players`, `matches` и `statistics`.

- **`sql_scripts/queries.sql`**  
  Содержит примеры SQL-запросов для анализа данных, например:
  - Подсчёт голов игроков за определённый период.
  - Сравнение результатов команд.
  - Анализ общей статистики.

- **`run_all.py`**  
  Основной скрипт для разворачивания базы данных. Выполняет следующие шаги:
  - Автоматическая проверяет наличие необходимых модулей (`pymysql`, `faker`). Если они отсутствуют, скрипт установит их самостоятельно.
  - Запрашивает параметры подключения к MySQL (`host`, `user`, `password`).
  - Запускает `create_tables.sql` для создания структуры базы.
  - Запускает `insert_data.py` для наполнения базы данными.
  - Открывает файл `queries.sql` в программе по умолчанию для просмотра запросов.

## Установка и запуск

### Предварительные требования

- Установленный MySQL (версия 5.7 или выше).
- Python 3.8 или выше.
- Установлены библиотеки:
  - `pymysql`
  - `faker`
  
### Подготовка к запуску

  1. **Распакуйте архив:**
   Скачайте и распакуйте файл `sql-sports-analysis-main.zip` в удобную директорию на вашем компьютере.

  2. **Запустите файл `run_all.py`:**
   - Откройте распакованную папку в проводнике.
   - Дважды щёлкните по файлу `run_all.py`, чтобы запустить его.

### Автоматическая установка зависимостей

При первом запуске скрипт `run_all.py` автоматически проверит наличие необходимых Python-модулей (`pymysql`, `faker`). Если их нет, скрипт установит их через `pip`. Пользователю не нужно вручную устанавливать зависимости.

### Процесс работы

  1. **Распакуйте архив** с проектом `sql-sports-analysis-main.zip` в удобное место.
   
  2. **Запустите `run_all.py`**:
   - Для этого достаточно дважды щёлкнуть по файлу `run_all.py` в проводнике. Это откроет окно, в котором будет выполнена вся необходимая логика для установки и запуска проекта.

  3. **Установка зависимостей**:
   - Если на вашем компьютере отсутствуют необходимые Python-модули (`pymysql`, `faker`), скрипт попросит вас подтвердить их установку. Вы можете согласиться, и скрипт автоматически установит недостающие модули. Если модули уже установлены, программа продолжит выполнение без вопросов.
   
  4. **Подключение к базе данных**:
   - После запуска скрипт запросит у вас следующие данные:
     - **Host** (например, `localhost`)
     - **Имя пользователя MySQL**
     - **Пароль MySQL**

  5. **Развёртывание базы данных**:
   - Скрипт выполнит SQL-скрипт для создания базы данных и таблиц, запустит Python-скрипт для добавления данных и откроет файл с примерами SQL-запросов для анализа.

  6. **Завершение**:
   - После успешного выполнения всех шагов, скрипт закроет соединение с базой данных и отобразит сообщение о завершении работы.

### Как установить зависимости вручную:

Если вам нужно установить зависимости вручную, используйте команду:
```bash
pip install pymysql faker

Теперь проект готов к использованию: вы можете выполнять собственные SQL-запросы или анализировать предоставленные примеры.