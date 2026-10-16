FROM python:3.13-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
COPY requirements.txt .
RUN --mount=type=secret,id=windows_ca \
    if [ -f /run/secrets/windows_ca ]; then export PIP_CERT=/run/secrets/windows_ca; fi; \
    pip install --no-cache-dir -r requirements.txt && useradd --create-home appuser
COPY app ./app
USER appuser
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
