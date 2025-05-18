-- 1. Создание базы данных
CREATE DATABASE markdown_notes_db
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Подключение к созданной базе данных
\c markdown_notes_db

-- 2. Создание таблиц
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notes (
    note_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user
        FOREIGN KEY(user_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE media (
    media_id SERIAL PRIMARY KEY,
    note_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    position INTEGER NOT NULL,
    url VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_note
        FOREIGN KEY(note_id) 
        REFERENCES notes(note_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_user
        FOREIGN KEY(user_id) 
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- 3. Создание триггеров
CREATE OR REPLACE FUNCTION update_note_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_note_timestamp
BEFORE UPDATE ON notes
FOR EACH ROW
EXECUTE FUNCTION update_note_timestamp();

CREATE OR REPLACE FUNCTION check_media_user_consistency()
RETURNS TRIGGER AS $$
DECLARE
    note_user_id INTEGER;
BEGIN
    SELECT user_id INTO note_user_id FROM notes WHERE note_id = NEW.note_id;
    
    IF NEW.user_id != note_user_id THEN
        RAISE EXCEPTION 'Media user_id must match note owner user_id';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_media_user_consistency
BEFORE INSERT OR UPDATE ON media
FOR EACH ROW
EXECUTE FUNCTION check_media_user_consistency();

-- 4. Создание индексов для ускорения запросов
CREATE INDEX idx_notes_user_id ON notes(user_id);
CREATE INDEX idx_media_note_id ON media(note_id);
CREATE INDEX idx_media_user_id ON media(user_id);

-- 5. Заполнение тестовыми данными
INSERT INTO users (username, email, password_hash) VALUES
('alice', 'alice@example.com', '$2a$10$xJwL5vZnXW7V8wVz7Qn7X.DhcIWfLZ3LdD7Jv6vUYQb0tKQ9rY9Zm'),
('bob', 'bob@example.com', '$2a$10$yH9eZnXW7V8wVz7Qn7X.DhcIWfLZ3LdD7Jv6vUYQb0tKQ9rY9Zm'),
('charlie', 'charlie@example.com', '$2a$10$zJwL5vZnXW7V8wVz7Qn7X.DhcIWfLZ3LdD7Jv6vUYQb0tKQ9rY9Zm');

INSERT INTO notes (user_id, title, content) VALUES
(1, 'Первая заметка Алисы', '# Заголовок\nЭто моя первая заметка.'),
(1, 'Рецепт пирога', '## Ингредиенты\n- Мука\n- Яйца\n- Сахар\n\n## Инструкции\n1. Смешать ингредиенты\n2. Выпекать 30 минут'),
(2, 'Заметка Боба', '### Привет, это Боб!\nЭто моя первая заметка в этом приложении.'),
(3, 'Список дел', '- [x] Купить молоко\n- [ ] Записаться к врачу\n- [ ] Позвонить маме');

INSERT INTO media (note_id, user_id, position, url, type) VALUES
(1, 1, 1, 'https://example.com/image1.jpg', 'image'),
(1, 1, 2, 'https://example.com/doc1.pdf', 'document'),
(2, 1, 1, 'https://example.com/image2.png', 'image'),
(3, 2, 1, 'https://example.com/photo1.jpg', 'image'),
(4, 3, 1, 'https://example.com/todo.mp3', 'audio');

-- 6. Проверочные запросы
SELECT 'База данных успешно создана и заполнена тестовыми данными' AS message;

-- Статистика
SELECT 
    (SELECT COUNT(*) FROM users) AS users_count,
    (SELECT COUNT(*) FROM notes) AS notes_count,
    (SELECT COUNT(*) FROM media) AS media_count;
