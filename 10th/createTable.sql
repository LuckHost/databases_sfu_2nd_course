-- Создание таблиц
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notes (
    note_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE media (
    media_id SERIAL PRIMARY KEY,
    note_id INTEGER NOT NULL REFERENCES notes(note_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    url VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

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

-- Триггер для проверки, что медиа принадлежит тому же пользователю, что и заметка
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