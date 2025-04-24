FROM python:3.11-slim

# gitをインストール
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# プロジェクトファイルをコピー
COPY pyproject.toml .
COPY src/ ./src/
COPY scripts/ ./scripts/
COPY create_agent.py deep_research.py README.md LICENSE .env.example ./

# uvとパッケージをインストール
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir uv && \
    uv pip install --no-cache-dir -e .

# ワークスペースディレクトリを作成
RUN mkdir -p /workspace
WORKDIR /workspace

# ダウンロードフォルダを作成
RUN mkdir -p downloads
RUN mkdir -p downloads_folder

# デフォルトの環境変数（実行時に上書き可能）
ENV OPENAI_API_KEY=""
ENV HF_TOKEN=""
ENV SERPER_API_KEY=""

# デフォルトのMCPサーバーポートを公開
EXPOSE 8080

# MCPサーバーを起動
ENTRYPOINT ["uv", "run", "deep_research.py"]
