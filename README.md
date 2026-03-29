# DevContainer Ansible Base Image

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

Ansible実行環境用のDevContainerベースイメージ

## 目次

- [DevContainer Ansible Base Image](#devcontainer-ansible-base-image)
  - [目次](#目次)
  - [1. 概要](#1-概要)
  - [2. 含まれるツール](#2-含まれるツール)
    - [2-1. システムツール](#2-1-システムツール)
    - [2-2. Ansible関連ツール](#2-2-ansible関連ツール)
    - [2-3. ユーザー設定](#2-3-ユーザー設定)
    - [2-4. Git設定](#2-4-git設定)
  - [3. 使い方](#3-使い方)
    - [3-1. GitHub Container Registryから使用](#3-1-github-container-registryから使用)
    - [3-2. ローカルでビルド](#3-2-ローカルでビルド)
  - [4. ビルド](#4-ビルド)
    - [4-1. GitHub Actionsでビルド](#4-1-github-actionsでビルド)
    - [4-2. 手動ビルド](#4-2-手動ビルド)
  - [5. カスタマイズ](#5-カスタマイズ)
  - [6. 更新](#6-更新)
  - [7. バージョン管理](#7-バージョン管理)

## 1. 概要

Debian 13 (trixie) + Python 3をベースとしたAnsible実行環境用Dockerイメージです。

VS CodeのDevContainer機能で使用することを想定しています。

## 2. 含まれるツール

### 2-1. システムツール

- Git
- curl
- wget
- vim
- nano
- direnv
- jq
- zip / unzip
- make
- bash-completion
- GitHub CLI（gh）

### 2-2. Ansible関連ツール

- Python 3
- pip
- Ansible
- ansible-lint
- yamllint
- Molecule
- sshpass
- rsync
- jmespath（json_queryフィルター用）

### 2-3. ユーザー設定

- ユーザー名: `vscode`
- UID/GID: 1000
- sudoアクセス: 有効

### 2-4. Git設定

```bash
user.name = 223n
user.email = 223n@223n.tech
core.autocrlf = input
core.eol = lf
init.defaultBranch = master
```

## 3. 使い方

### 3-1. GitHub Container Registryから使用

`.devcontainer/devcontainer.json`:

```json
{
  "name": "Ansible Project",
  "image": "ghcr.io/223n/devcontainer-ansible-base:latest",
  "runArgs": ["--name", "ansible-dev"],
  "remoteUser": "vscode",
  "workspaceFolder": "/workspaces/${localWorkspaceFolderBasename}"
}
```

### 3-2. ローカルでビルド

```bash
docker build -t 223n-devcontainer-ansible-base:latest .
```

`.devcontainer/devcontainer.json`:

```json
{
  "name": "Ansible Project",
  "image": "223n-devcontainer-ansible-base:latest",
  "runArgs": ["--name", "ansible-dev"],
  "remoteUser": "vscode"
}
```

## 4. ビルド

### 4-1. GitHub Actionsでビルド

GitHub Actionsの手動実行（workflow_dispatch）でビルドとリリースを行います。

### 4-2. 手動ビルド

```bash
# ビルド
docker build -t ghcr.io/223n/devcontainer-ansible-base:latest .

# プッシュ（要認証）
docker push ghcr.io/223n/devcontainer-ansible-base:latest
```

## 5. カスタマイズ

プロジェクト固有の設定が必要な場合は、このイメージをベースにカスタマイズできます。

```dockerfile
FROM ghcr.io/223n/devcontainer-ansible-base:latest

# プロジェクト固有のcollectionsをインストール
RUN ansible-galaxy collection install community.general

# requirements.ymlからインストール
COPY requirements.yml /tmp/requirements.yml
RUN ansible-galaxy install -r /tmp/requirements.yml
```

## 6. 更新

ベースイメージを更新した場合は、ローカルイメージを更新してからDevContainerを再ビルドしてください。

```bash
# ローカルイメージの更新
docker pull ghcr.io/223n/devcontainer-ansible-base:latest

# DevContainerの再ビルド
# VS Code: "Dev Containers: Rebuild Container"
```

## 7. バージョン管理

- `latest`: 最新の安定版
- `1.0.0`: 完全バージョン
- `1.0`: マイナーバージョン
- `1`: メジャーバージョン
- `sha-<commit-sha>`: 特定コミット
