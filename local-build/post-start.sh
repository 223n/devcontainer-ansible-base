#!/bin/bash
# ========================================
# DevContainer起動後の初期化スクリプト
# ========================================

# .envrcが存在しない場合はテンプレートからコピー
if [ ! -f .envrc ]; then
    echo "📋 .envrcが見つかりません。テンプレートをコピーします..."
    cp .envrc.template .envrc
    echo "✅ .envrcを作成しました。必要に応じて編集してください。"
fi

# direnvを許可
direnv allow
echo "✅ direnvを許可しました。環境変数が自動的に読み込まれます。"
