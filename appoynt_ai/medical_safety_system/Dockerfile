# ==============================================================================
# Dockerfile — Healthcare AI API
# Base Image  : python:3.11-slim
# Target      : Render.com production deployment
# Entry Point : uvicorn main:app (port from $PORT env var, default 8000)
# ==============================================================================

FROM python:3.11-slim

# ---------------------------------------------------------------------------
# System dependencies
#   libgomp1  : OpenMP runtime required by LightGBM and some FAISS builds
#   build-essential / gcc : needed by some Python C-extension packages
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        libgomp1 \
        build-essential \
        gcc \
        curl \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Working directory inside the container
# ---------------------------------------------------------------------------
WORKDIR /app

# ---------------------------------------------------------------------------
# Install Python dependencies first (Docker layer cache optimisation)
# ---------------------------------------------------------------------------
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ---------------------------------------------------------------------------
# Download the spaCy English model used by Task 1 NLP extractor
# ---------------------------------------------------------------------------
RUN python -m spacy download en_core_web_sm

# ---------------------------------------------------------------------------
# Copy the full application source
# ---------------------------------------------------------------------------
COPY . .

# ---------------------------------------------------------------------------
# Expose port (documentation only — Render binds dynamically via )
# ---------------------------------------------------------------------------
EXPOSE 8000

# ---------------------------------------------------------------------------
# Start the unified server.
# Render injects ; fall back to 8000 for local testing.
# ---------------------------------------------------------------------------
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port "]
