<!--
  出典: 223n/Cat-Server-Information-Survey の doc/AnsibleVaultGuid.md
  同リポジトリのアーカイブに伴い、内容を保つためこちらへ移設した。
-->

# Ansible Vault: 機密情報の暗号化ガイド

## 1. Ansible Vaultとは

Ansible Vaultは、パスワード、APIキー、SSH鍵などの機密情報を安全に暗号化・管理するためのツールです。以下の主要な機能を提供します：

- 機密ファイルの暗号化
- 変数の暗号化
- パスワードベースの暗号化

## 2. 基本的な使用方法

### 2.1 Vault パスワードの作成

Vault用のパスワードファイルを作成します：

```bash
# パスワードファイルの作成
echo "your_secure_vault_password" > ~/.vault-password

# ファイルのパーミッションを変更
chmod 600 ~/.vault-password
```

### 2.2 ファイルの暗号化

#### 新規ファイルの暗号化
```bash
# 対話形式でファイルを暗号化
ansible-vault encrypt sensitive_vars.yml

# パスワードファイルを使用して暗号化
ansible-vault encrypt --vault-password-file=~/.vault-password sensitive_vars.yml
```

#### 既存のファイルを暗号化
```bash
# ファイルを暗号化
ansible-vault encrypt inventory
ansible-vault encrypt group_vars/all.yml
```

### 2.3 暗号化されたファイルの表示

```bash
# 暗号化されたファイルの内容を表示
ansible-vault view sensitive_vars.yml

# パスワードファイルを使用して表示
ansible-vault view --vault-password-file=~/.vault-password sensitive_vars.yml
```

### 2.4 ファイルの編集

```bash
# 暗号化されたファイルを安全に編集
ansible-vault edit sensitive_vars.yml

# パスワードファイルを使用して編集
ansible-vault edit --vault-password-file=~/.vault-password sensitive_vars.yml
```

### 2.5 ファイルの復号化

```bash
# ファイルを復号化
ansible-vault decrypt sensitive_vars.yml

# パスワードファイルを使用して復号化
ansible-vault decrypt --vault-password-file=~/.vault-password sensitive_vars.yml
```

## 3. プレイブックでの使用

### 3.1 パスワードファイルを指定して実行

```bash
# パスワードファイルを使用してプレイブックを実行
ansible-playbook --vault-password-file=~/.vault-password server_playbook.yml
```

### 3.2 プロンプトでパスワードを入力

```bash
# 実行時にパスワードを入力
ansible-playbook --ask-vault-pass server_playbook.yml
```

## 4. 暗号化の対象

以下のようなファイルやデータを暗号化できます：

- インベントリファイル
- 変数ファイル
- SSH鍵
- データベース接続情報
- APIキー
- その他の機密情報

## 5. セキュリティのベストプラクティス

1. Vault用のパスワードは強力で複雑なものを使用
2. パスワードファイルは厳重に管理（600パーミッション）
3. バージョン管理システムには平文のパスワードを絶対に保存しない
4. 定期的にパスワードを変更

## 6. 暗号化の例：インベントリファイル

```yaml
# inventory.yml の例
[servers]
server1 ansible_host=example.com 
    ansible_user=webuser 
    # 機密情報は暗号化
    ansible_ssh_pass=!vault |
          $ANSIBLE_VAULT;1.1;AES256
          [暗号化されたパスワード]

# または別ファイルに分離
[servers:vars]
ansible_ssh_pass={{ vault_ssh_password }}
```

## 7. トラブルシューティング

- パスワードを忘れた場合、ファイルを復元することはできません
- 複数の環境で同じVaultファイルを使用する場合は、一元化された安全なパスワード管理が重要

## 注意事項

- Vault暗号化は機密情報を保護しますが、絶対的なセキュリティを保証するものではありません
- 適切なアクセス制御、ネットワークセキュリティと組み合わせて使用してください

## まとめ

Ansible Vaultは、機密情報を安全に管理するための強力なツールです。適切に使用することで、インフラストラクチャの セキュリティを大幅に向上させることができます。
