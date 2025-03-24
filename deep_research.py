from typing import Any, List, Dict
import os
from mcp.server.fastmcp import FastMCP
from dotenv import load_dotenv
import logging
import datetime

from create_agent import create_agent

# 環境変数を読み込む
load_dotenv()

# ロギングの設定
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("deep_research.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger("deep_research")

# Initialize FastMCP server
mcp = FastMCP("deep_research")

# 環境変数の確認
if not os.environ.get("OPENAI_API_KEY"):
    logger.error("警告: OPENAI_API_KEY環境変数が設定されていません。")
elif not os.environ.get("HF_TOKEN"):
    logger.error("警告: HF_TOKEN環境変数が設定されていません。")
elif not os.environ.get("SERPER_API_KEY"):
    logger.error("警告: SERPER_API_KEY環境変数が設定されていません。")

# ブラウザを操作するAgent
agent = create_agent(model_id="o3-mini")

@mcp.tool()
async def deep_research(question: str) -> str:
    """web検索を含む深い調査をAgentに依頼する。調査は専用のエージェントが実行するため、必要なコンテキストを全て含めたquestionを渡す。
    複雑な質問にも対応できるため基本的に疑問はそのまま質問し、回答の質が悪い場合にのみ複数ステップに分けた調査を依頼する。

    Args:
        question: 質問文（必要なコンテキストを全て含む文章）
    """
    # ログに検索履歴を記録
    logger.info(f"検索クエリ: {question}")
    
    try:
        # Open Deep Researchのエージェントによる調査の実行
        answer = agent.run(question)
        
        # ログに回答を記録
        logger.info(f"調査結果: {answer}")
        
        return answer
    
    except Exception as e:
        error_message = f"エラーが発生しました: {str(e)}"
        logger.error(error_message)
        return error_message

if __name__ == "__main__":
    # Initialize and run the server
    mcp.run(transport='stdio')
