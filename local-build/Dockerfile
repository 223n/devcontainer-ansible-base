# ========================================
# プロジェクト固有のDevContainer設定
# Ansibleベースイメージを使用
# ========================================

# ローカルビルド版のベースイメージを使用
ARG TAG=latest
FROM 223n-devcontainer-ansible-base:${TAG}

# GitHub Container Registry版を使用する場合はコメントを切り替え
# FROM ghcr.io/223n/devcontainer-ansible-base:${TAG}

# プロジェクト固有の設定やツールがあればここに追加
# 例: RUN ansible-galaxy collection install community.general

# ユーザーはベースイメージで設定済み (vscode)
USER vscode

# デフォルトシェル
SHELL ["/bin/bash", "-c"]
