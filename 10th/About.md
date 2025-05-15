[User] ----1----< [Note] ----1----< [Media]

# Проектирование базы данных для приложения заметок в MarkDown

## Концептуальная модель (ER-диаграмма)

```
[User] ----1----< [Note] ----1----< [Media]
```

Сущности:
- User - пользователь приложения
- Note - заметка пользователя
- Media - мультимедийный файл в заметке

Связи:
- Один пользователь может иметь много заметок (1:N)
- Одна заметка может содержать много медиафайлов (1:N)

## Логическая модель

Преобразование сущностей в таблицы:

1. Users (Пользователи)
   - user_id (PK)
   - username
   - email
   - password_hash
   - created_at

2. Notes (Заметки)
   - note_id (PK)
   - user_id (FK)
   - title
   - content (Markdown текст)
   - created_at
   - updated_at

3. Media (Мультимедиа)
   - media_id (PK)
   - note_id (FK)
   - user_id (FK)
   - position (порядок в заметке)
   - url (ссылка на файл)
   - type (тип файла: image, video, audio и т.д.)
   - uploaded_at

