# ========================================
# Ansible実行環境用DevContainerベースイメージ
# Debian 13 (trixie) + Python 3 + Ansible
# User: vscode
# ========================================

ARG TAG=trixie-slim
FROM debian:${TAG}

# メタデータ
LABEL org.opencontainers.image.source="https://github.com/223n/devcontainer-ansible-base"
LABEL org.opencontainers.image.description="DevContainer base image for Ansible on Debian 13"
LABEL org.opencontainers.image.licenses="MIT"

# 非対話的インストールの設定
ENV DEBIAN_FRONTEND=noninteractive

# 基本パッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    # 開発ツール
    git \
    curl \
    wget \
    vim \
    nano \
    ca-certificates \
    gnupg \
    # シェル環境
    direnv \
    bash-completion \
    openssh-client \
    # 日本語ロケール
    locales \
    # その他便利ツール
    jq \
    zip \
    unzip \
    # Python関連
    python3 \
    python3-pip \
    python3-venv \
    # ビルドツール
    make \
    # Ansible依存パッケージ
    sshpass \
    rsync \
    python3-jmespath \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# GitHub CLI のインストール
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && printf '%s\n' \
      "Types: deb" \
      "URIs: https://cli.github.com/packages" \
      "Suites: stable" \
      "Components: main" \
      "Architectures: $(dpkg --print-architecture)" \
      "Signed-By: /usr/share/keyrings/githubcli-archive-keyring.gpg" \
      > /etc/apt/sources.list.d/github-cli.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ansible関連パッケージのインストール
# NOTE: Debian Trixieではpipのexternally-managed-environment制約があるため
#       --break-system-packagesを使用（コンテナ内なので安全）
RUN pip install --no-cache-dir --break-system-packages \
    ansible \
    ansible-lint \
    yamllint \
    molecule

# 日本語ロケールを生成・設定
RUN sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# vscodeユーザーの作成
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m -s /bin/bash vscode \
    && apt-get update \
    && apt-get install -y --no-install-recommends sudo \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# vscodeユーザーに切り替え
USER vscode

# Git グローバル設定
RUN git config --global user.name "223n" \
    && git config --global user.email "223n@223n.tech" \
    && git config --global core.autocrlf input \
    && git config --global core.eol lf \
    && git config --global init.defaultBranch master \
    && git config --global pull.rebase false \
    && git config --global core.editor "nano"

# gitの安全なディレクトリに追加（vscodeユーザー用）
RUN git config --global --add safe.directory /workspace

# direnv自動読み込み設定
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# bash補完の有効化
RUN echo '[ -f /etc/bash_completion ] && . /etc/bash_completion' >> ~/.bashrc

# プロンプトのカスタマイズ
RUN echo 'export PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ "' >> ~/.bashrc

# 作業ディレクトリの設定
WORKDIR /home/vscode

# デフォルトシェル
SHELL ["/bin/bash", "-c"]

# バージョン確認用
RUN python3 --version && ansible --version && ansible-lint --version && git --version && gh --version

# ヘルスチェック
HEALTHCHECK NONE

# デフォルトコマンド
CMD ["/bin/bash"]
