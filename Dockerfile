FROM python:3.11-slim

# Install git
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml .
COPY src/ ./src/
COPY scripts/ ./scripts/
COPY create_agent.py deep_research.py README.md LICENSE .env.example ./

# Install uv and the package
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir uv && \
    uv pip install --no-cache-dir -e .

# Create a directory for workspace
RUN mkdir -p /workspace
WORKDIR /workspace

# Default environment variables (can be overridden at runtime)
ENV OPENAI_API_KEY=""
ENV HF_TOKEN=""
ENV SERPER_API_KEY=""

# Expose the default MCP server port
EXPOSE 8080

# Start the MCP server
ENTRYPOINT ["uv", "run", "deep_research.py"]
