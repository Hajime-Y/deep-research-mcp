# Deep Research MCP Server

Deep Research is an agent-based tool that provides web search and advanced research capabilities. It leverages HuggingFace's `smolagents` and is implemented as an MCP server.

This project is based on [HuggingFace's open_deep_research example](https://github.com/huggingface/smolagents/tree/main/examples/open_deep_research).

## Features

- Web search and information gathering
- PDF and document analysis
- Image analysis and description
- YouTube transcript retrieval
- Archive site search

## Requirements

- Python 3.11 or higher
- `uv` package manager
- The following API keys:
  - OpenAI API key
  - HuggingFace token
  - SerpAPI key

## Installation

1. Clone the repository:

```bash
git clone https://github.com/Hajime-Y/deep-research-mcp.git
cd deep-research-mcp
```

2. Create a virtual environment and install dependencies:

```bash
uv venv
source .venv/bin/activate # For Linux or Mac
# .venv\Scripts\activate # For Windows
uv sync
```

## Environment Variables

Create a `.env` file in the root directory of the project and set the following environment variables:

```
OPENAI_API_KEY=your_openai_api_key
HF_TOKEN=your_huggingface_token
SERPER_API_KEY=your_serper_api_key
```

You can obtain a SERPER_API_KEY by signing up at [Serper.dev](https://serper.dev/signup).

## Usage

Start the MCP server:

```bash
uv run deep_research.py
```

This will launch the `deep_research` agent as an MCP server.

## Docker Usage

You can also run this MCP server in a Docker container:

```bash
# Build the Docker image
docker build -t deep-research-mcp .

# Run with required API keys
docker run -p 8080:8080 \
  -e OPENAI_API_KEY=your_openai_api_key \
  -e HF_TOKEN=your_huggingface_token \
  -e SERPER_API_KEY=your_serper_api_key \
  deep-research-mcp
```

### Registering with MCP Clients

To register this Docker container as an MCP server in different clients:

#### Claude Desktop

Add the following to your Claude Desktop configuration file (typically located at `~/.config/Claude/claude_desktop_config.json` on Linux, `~/Library/Application Support/Claude/claude_desktop_config.json` on macOS, or `%APPDATA%\Claude\claude_desktop_config.json` on Windows):

```json
{
  "mcpServers": {
    "deep-research-mcp": {
      "command": "docker",
      "args": [
        "run", 
        "-i", 
        "--rm", 
        "-e", "OPENAI_API_KEY=your_openai_api_key",
        "-e", "HF_TOKEN=your_huggingface_token", 
        "-e", "SERPER_API_KEY=your_serper_api_key",
        "deep-research-mcp"
      ]
    }
  }
}
```

#### Cursor IDE

For Cursor IDE, add the following configuration:

```json
{
  "mcpServers": {
    "deep-research-mcp": {
      "command": "docker",
      "args": [
        "run", 
        "-i", 
        "--rm", 
        "-e", "OPENAI_API_KEY=your_openai_api_key",
        "-e", "HF_TOKEN=your_huggingface_token", 
        "-e", "SERPER_API_KEY=your_serper_api_key",
        "deep-research-mcp"
      ]
    }
  }
}
```

#### Using with Remote MCP Server

If you're running the MCP server on a remote machine or exposing it as a service, you can use the URL-based configuration:

```json
{
  "mcpServers": {
    "deep-research-mcp": {
      "url": "http://your-server-address:8080/mcp",
      "type": "sse"
    }
  }
}
```

## Key Components

- `deep_research.py`: Entry point for the MCP server
- `create_agent.py`: Agent creation and configuration
- `scripts/`: Various tools and utilities
  - `text_web_browser.py`: Text-based web browser
  - `text_inspector_tool.py`: File inspection tool
  - `visual_qa.py`: Image analysis tool
  - `mdconvert.py`: Converts various file formats to Markdown

## License

This project is provided under the Apache License 2.0.

## Acknowledgements

This project uses code from HuggingFace's `smolagents` and Microsoft's `autogen` projects.