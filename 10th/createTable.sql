-- Создание базы данных
DROP DATABASE markdown_notes_db;



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

--- 1. Создание таблицы пользователей
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);

-- 2. Создание таблицы заметок
CREATE TABLE notes (
    note_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- 3. Создание таблицы типов медиа
CREATE TABLE media_types (
    type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    allowed_extensions VARCHAR[] DEFAULT '{}'
);

-- 4. Создание таблицы медиафайлов
CREATE TABLE media (
    media_id SERIAL PRIMARY KEY,
    note_id INTEGER NOT NULL REFERENCES notes(note_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    type_id INTEGER NOT NULL REFERENCES media_types(type_id),
    position INTEGER NOT NULL CHECK (position > 0),
    original_filename VARCHAR(255) NOT NULL,
    storage_path VARCHAR(512) NOT NULL,
    file_size BIGINT NOT NULL CHECK (file_size > 0),
    width INTEGER,
    height INTEGER,
    duration INTEGER,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_position_per_note UNIQUE (note_id, position)
);

-- 5. Создание таблицы тегов заметок
CREATE TABLE note_tags (
    tag_id SERIAL PRIMARY KEY,
    note_id INTEGER NOT NULL REFERENCES notes(note_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    tag_name VARCHAR(50) NOT NULL,
    color VARCHAR(7),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_tag_per_note UNIQUE (note_id, tag_name)
);

-- Индексы для ускорения запросов
CREATE INDEX idx_notes_user_id ON notes(user_id);
CREATE INDEX idx_media_note_id ON media(note_id);
CREATE INDEX idx_media_user_id ON media(user_id);
CREATE INDEX idx_note_tags_note_id ON note_tags(note_id);
CREATE INDEX idx_note_tags_user_id ON note_tags(user_id);

-- Триггер для автоматического обновления updated_at при изменении заметки
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

-- Триггер для проверки целостности медиафайлов
CREATE OR REPLACE FUNCTION check_media_consistency()
RETURNS TRIGGER AS $$
DECLARE
    note_user_id INTEGER;
BEGIN
    -- Проверка, что пользователь медиа совпадает с владельцем заметки
    SELECT user_id INTO note_user_id FROM notes WHERE note_id = NEW.note_id;
    
    IF NEW.user_id != note_user_id THEN
        RAISE EXCEPTION 'Media must belong to the same user as the note';
    END IF;
    
    -- Дополнительные проверки в зависимости от типа медиа
    IF (SELECT name FROM media_types WHERE type_id = NEW.type_id) = 'image' THEN
        IF NEW.width IS NULL OR NEW.height IS NULL THEN
            RAISE EXCEPTION 'Image media must have width and height specified';
        END IF;
    ELSIF (SELECT name FROM media_types WHERE type_id = NEW.type_id) = 'video' THEN
        IF NEW.duration IS NULL THEN
            RAISE EXCEPTION 'Video media must have duration specified';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_media_consistency
BEFORE INSERT OR UPDATE ON media
FOR EACH ROW
EXECUTE FUNCTION check_media_consistency();

-- Триггер для ограничения количества тегов на заметку
CREATE OR REPLACE FUNCTION limit_note_tags()
RETURNS TRIGGER AS $$
DECLARE
    tag_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO tag_count FROM note_tags WHERE note_id = NEW.note_id;
    
    IF tag_count >= 10 THEN
        RAISE EXCEPTION 'A note cannot have more than 10 tags';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_limit_note_tags
BEFORE INSERT ON note_tags
FOR EACH ROW
EXECUTE FUNCTION limit_note_tags();
-- Добавление типов медиа
INSERT INTO media_types (name, description, allowed_extensions) VALUES
('image', 'Изображения', ARRAY['jpg', 'jpeg', 'png', 'gif']),
('video', 'Видеофайлы', ARRAY['mp4', 'mov', 'avi']),
('audio', 'Аудиофайлы', ARRAY['mp3', 'wav', 'ogg']),
('document', 'Документы', ARRAY['pdf', 'docx', 'txt']);

-- Добавление пользователей
INSERT INTO users (username, email, password_hash) VALUES
('alice', 'alice@example.com', 'hash1'),
('bob', 'bob@example.com', 'hash2'),
('charlie', 'charlie@example.com', 'hash3');

-- Добавление заметок
INSERT INTO notes (user_id, title, content, is_public) VALUES
(1, 'Первая заметка', '# Заголовок\nЭто моя первая заметка.', TRUE),
(1, 'Рецепт пирога', '## Ингредиенты\n- Мука\n- Яйца', FALSE),
(2, 'Рабочие заметки', '### Задачи\n- [x] Проект А\n- [ ] Проект Б', TRUE),
(3, 'Личный дневник', 'Сегодня был прекрасный день...', FALSE);

-- Добавление тегов
INSERT INTO note_tags (note_id, user_id, tag_name, color) VALUES
(1, 1, 'важно', '#FF0000'),
(1, 1, 'работа', '#00FF00'),
(2, 1, 'рецепты', '#0000FF'),
(3, 2, 'работа', '#00FF00'),
(4, 3, 'личное', '#FF00FF');

-- Добавление медиафайлов
INSERT INTO media (note_id, user_id, type_id, position, original_filename, storage_path, file_size, width, height, duration) VALUES
(1, 1, 1, 1, 'image1.jpg', '/uploads/1/image1.jpg', 102400, 800, 600, NULL),
(1, 1, 4, 2, 'doc.pdf', '/uploads/1/doc.pdf', 51200, NULL, NULL, NULL),
(2, 1, 1, 1, 'cake.jpg', '/uploads/1/cake.jpg', 204800, 1200, 800, NULL),
(3, 2, 3, 1, 'meeting.mp3', '/uploads/2/meeting.mp3', 307200, NULL, NULL, 3600),
(4, 3, 2, 1, 'video.mp4', '/uploads/3/video.mp4', 409600, 1920, 1080, 120);
-- 6. Проверочные запросы
SELECT 'База данных успешно создана и заполнена тестовыми данными' AS message;

-- Статистика
SELECT 
    (SELECT COUNT(*) FROM users) AS users_count,
    (SELECT COUNT(*) FROM notes) AS notes_count,
    (SELECT COUNT(*) FROM media) AS media_count;
