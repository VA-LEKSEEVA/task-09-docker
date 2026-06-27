# ====== STAGE 1: сборка зависимостей ======
FROM python:3.12-slim AS builder

# Устанавливаем uv (быстрый установщик)
RUN pip install --no-cache-dir uv

WORKDIR /app

# Копируем только файл с зависимостями
COPY pyproject.toml .

# Устанавливаем зависимости в системный site-packages (без виртуального окружения)
# Это упрощает копирование на следующий этап
RUN uv pip install --system --no-cache-dir -e .

# ====== STAGE 2: финальный образ ======
FROM python:3.12-slim

# Создаём непривилегированного пользователя
RUN groupadd --system app && \
    useradd --system --gid app --no-create-home app

WORKDIR /app

# Копируем установленные пакеты из builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# Копируем код приложения
COPY --chown=app:app app.py .

# Переключаемся на не-root пользователя
USER app

# Переменные окружения для Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

CMD ["python", "app.py"]
