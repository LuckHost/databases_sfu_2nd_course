-- Добавление пользователей
INSERT INTO users (username, email, password_hash) VALUES
('alice', 'alice@example.com', 'hash1'),
('bob', 'bob@example.com', 'hash2');

-- Добавление заметок
INSERT INTO notes (user_id, title, content) VALUES
(1, 'Первая заметка Алисы', '# Заголовок\nЭто моя первая заметка.'),
(1, 'Рецепт пирога', '## Ингредиенты\n- Мука\n- Яйца\n- Сахар'),
(2, 'Заметка Боба', 'Привет, это Боб!');

-- Добавление медиафайлов
INSERT INTO media (note_id, user_id, position, url, type) VALUES
(1, 1, 1, 'https://example.com/image1.jpg', 'image'),
(1, 1, 2, 'https://example.com/doc1.pdf', 'document'),
(2, 1, 1, 'https://example.com/image2.png', 'image');