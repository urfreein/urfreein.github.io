---
title: "Vultr Firewall完全ガイド：クラウドサーバーのセキュリティ設定方法"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "VultrのWebベースファイアウォール機能を活用したクラウドサーバーのセキュリティ設定方法。Firewall Groupの作成から実践活用まで完全ガイド。"
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A professional, technical illustration depicting cloud firewall security concept.
- Style: Clean, modern technical diagram style with minimalist design
- Subject: Network firewall shield icon protecting cloud server instances
- Elements: Firewall shield in center, multiple server icons behind it, network traffic arrows (green for allowed, red for blocked), cloud infrastructure background
- Colors: Blue and white for security theme, green for allowed traffic, red for blocked traffic, gray for servers
- Mood: Professional, secure, trustworthy, technical
- Composition: Central firewall shield with bidirectional traffic flow visualization

Technical keywords: Vultr, firewall, cloud security, network protection, server infrastructure

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/vultr-firewall-setup-guide-featured.jpg

NOTE: Hugo will serve this from /images/vultr-firewall-setup-guide-featured.jpg
-->

## 1. Vultr Firewallとは？

Vultr FirewallはWebベースのファイアウォールサービスです。
クラウドインスタンスにトラフィックが到達する前にパケットをフィルタリングします。

### 1.1 なぜ必要なのか？

サーバーセキュリティは多層防御が基本です。
ホストファイアウォール（UFW、firewalld）だけでは不十分です。

Vultr Firewallはネットワークレベルで動作します。
したがって、悪意のあるトラフィックがサーバーに到達する前にブロックされます。

### 1.2 ホストファイアウォールとの違い

**ホストファイアウォール（UFW、firewalld）：**
- サーバーOS内で動作
- トラフィックがサーバーに到達した後にフィルタリング
- CPU/メモリリソースを使用

**Vultr Firewall：**
- Vultrネットワークレベルで動作  
- トラフィックがサーバーに到達する前にブロック
- サーバーリソースに影響なし

したがって、両方を併用するのが最も安全です。

### 1.3 Firewall Groupの概念

Vultr Firewallはグループ単位で管理されます。
1つのFirewall Groupに複数のルールを追加します。
そして、このグループを複数のインスタンスに適用できます。

例えば：
- Webサーバー用グループ：HTTP/HTTPSを許可
- DBサーバー用グループ：特定IPからのみDBポートを許可  
- 開発サーバー用グループ：SSHのみ許可

## 2. Firewall Groupの作成

### 2.1 ポータルから作成

Vultr Customer Portalにログインします。

1. **Products → Network → Firewall**メニューに移動
2. **Add Firewall**ボタンをクリック
3. **Description**フィールドにグループ名を入力
4. **Add Firewall Group**ボタンをクリック

グループが作成されました。
ただし、まだルールのない空のグループです。

### 2.2 APIで作成

APIを使用すると自動化が可能です。

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

レスポンスとしてFirewall Group IDを受け取ります。
このIDを覚えておきましょう。

### 2.3 Terraformで管理

インフラをコードとして管理する場合はTerraformを使用します。

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

コードで管理すればバージョン管理が可能です。
チームメンバーとの協業にも便利です。

## 3. ファイアウォールルールの設定

### 3.1 基本ルールの追加

Firewall Groupをクリックしてルール管理画面に入ります。

**IPv4 Ruleを追加：**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

これで、すべての場所からHTTPアクセスが可能になります。

### 3.2 SSHアクセスの制限

SSHは特定のIPからのみアクセス可能にします。

**IPv4 Rule：**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89（あなたのIP）

これで、あなたのIPからのみSSHアクセスが可能です。
他のIPからはブロックされます。

### 3.3 複数ポートを一度に開く

Webサーバーは、HTTPとHTTPSの両方を開く必要があります。

**ルール1 - HTTP：**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**ルール2 - HTTPS：**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 APIでルールを追加

```bash
curl "https://api.vultr.com/v2/firewalls/{firewall-id}/rules" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "ip_type": "v4",
    "protocol": "tcp",
    "subnet": "0.0.0.0",
    "subnet_size": 0,
    "port": "80",
    "notes": "Allow HTTP"
  }'
```

自動化スクリプトで便利です。

### 3.5 Terraformでルールを定義

```hcl
resource "vultr_firewall_rule" "allow_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "Allow HTTP traffic"
}

resource "vultr_firewall_rule" "allow_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "Allow HTTPS traffic"
}

resource "vultr_firewall_rule" "allow_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "123.45.67.89"
  subnet_size       = 32
  port              = "22"
  notes             = "Allow SSH from my IP"
}
```

## 4. インスタンスへの接続

### 4.1 ポータルから接続

ルールを作成したら、インスタンスに適用する必要があります。

1. **Products → Compute**メニューに移動
2. 対象インスタンスをクリック
3. **Settings → Firewall**メニューへ
4. Firewallドロップダウンからグループを選択
5. **Update Firewall Group**ボタンをクリック

即座に適用されます。

### 4.2 複数インスタンスへの適用

同じ役割のサーバーが複数ある場合は？
各インスタンスに同じFirewall Groupを適用します。

例えば：
- Webサーバー3台
- すべて同じファイアウォールルールが必要

したがって、1つのFirewall Groupを3台すべてに適用します。
ルールを変更すると、3台すべてに即座に反映されます。

### 4.3 APIで接続

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

自動デプロイスクリプトで使用します。

### 4.4 Terraformで管理

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

インスタンス作成と同時にファイアウォールを適用します。

## 5. 実践的な使用例

### 5.1 Webサーバーの保護

Webサーバーは、HTTP、HTTPS、SSHのみを開けば十分です。

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # あなたのIPのみ
  subnet_size       = 32
}

resource "vultr_firewall_rule" "web_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "80"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}

resource "vultr_firewall_rule" "web_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "443"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}
```

他のすべてのポートは自動的にブロックされます。

### 5.2 データベースサーバー

DBサーバーは、Webサーバーからのみアクセス可能にする必要があります。

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # WebサーバーのプライベートIP
  subnet_size       = 32
}
```

パブリックIPではDBにアクセスできません。
プライベートネットワーク経由でのみ可能です。

### 5.3 Load Balancerとの連携

Load Balancerを使用する場合は？
WebサーバーはLoad Balancerからのみトラフィックを受け取る必要があります。

**ルール設定：**
- Protocol: TCP
- Port: 80
- Source: Load Balancer（LB IDを入力）

これにより、Load Balancerを迂回した直接アクセスがブロックされます。

## 6. セキュリティのベストプラクティス

### 6.1 デフォルトポリシー：すべて拒否

Vultr Firewallのデフォルトポリシーは「すべてブロック」です。
したがって、明示的に許可されたトラフィックのみが通過します。

これが正しいアプローチです。
必要なものだけを開く必要があります。

### 6.2 最小権限の原則

すべてのIPに対してSSHを開いてはいけません。
ブルートフォース攻撃の標的になります。

したがって、特定のIPのみを許可します：
- オフィスIP
- VPN IP
- 自宅IP

### 6.3 多層防御

Vultr Firewallだけで十分でしょうか？
いいえ。ホストファイアウォールも一緒に使用する必要があります。

**防御層：**
1. Vultr Firewall（ネットワークレベル）
2. ホストファイアウォール（OSレベル）
3. アプリケーションファイアウォール（アプリレベル）

したがって、UFWやfirewalldも設定します。

### 6.4 本番環境適用前のテスト

ファイアウォール設定を間違えると？
サービスが中断されます。

したがって、必ず：
1. 開発環境でテスト
2. ステージング環境で検証
3. 本番環境に適用

### 6.5 定期的なルールの見直し

一度設定して終わりではありません。
定期的にルールを見直します：

- 不要なルールの削除
- もう使用していないIPの削除
- 新しいセキュリティ要件の反映

## 7. トラブルシューティング

### 7.1 接続できない場合

SSHやWeb接続ができない場合は？

**チェックリスト：**
1. Firewall Groupがインスタンスに接続されているか？
2. ポートを許可するルールがあるか？
3. ソースIPは正しいか？
4. ホストファイアウォールも確認

### 7.2 ルール適用時間

Firewall Groupの変更は即座に適用されます。
ただし、ネットワーク伝播に数秒かかることがあります。

接続テストは10-20秒後に試してください。

### 7.3 ログの確認

Vultr Firewall自体はログを提供しません。
したがって、ホストファイアウォールのログを確認する必要があります。

**UFWログ：**
```bash
sudo tail -f /var/log/ufw.log
```

**Firewalldログ：**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 ルールの優先順位

Vultr Firewallには、ルールの順序はありません。
すべてのルールはOR条件で動作します。

つまり、1つでもマッチすれば許可されます。

## 8. CLIと自動化

### 8.1 Vultr CLIのインストール

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

API Keyを設定します：
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Firewall Groupの管理

**グループ一覧：**
```bash
vultr-cli firewall group list
```

**グループ作成：**
```bash
vultr-cli firewall group create --description "Web Server"
```

**ルール追加：**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 デプロイの自動化

新しいインスタンスをデプロイする際、自動的にファイアウォールを適用します：

```bash
#!/bin/bash

# インスタンス作成
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Firewallを適用
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. コストと制限

### 9.1 コスト

Vultr Firewallは**完全無料**です。
追加費用は一切かかりません。

したがって、すべてのインスタンスに適用することを推奨します。

### 9.2 制限

**Firewall Group：**
- アカウントあたり最大50個

**ルール：**
- グループあたり最大50ルール

ほとんどの場合、十分です。
さらに必要な場合は、サポートに問い合わせてください。

### 9.3 Load Balancer Firewallとの違い

Vultr Load Balancerには別のファイアウォールがあります。
両者は異なります：

**Vultr Firewall：**
- インスタンスを保護
- ネットワークレベルフィルタリング

**Load Balancer Firewall：**
- Load Balancerを保護
- LBに入るトラフィックをフィルタリング

したがって、Load Balancerを使用する場合は、両方を設定します。

## 10. まとめ

### 10.1 Vultr Firewallの利点

- 無料
- ネットワークレベルの保護
- 複数のインスタンスに簡単に適用
- API/CLI/Terraformサポート
- サーバーリソースの使用なし

### 10.2 いつ使用するか？

**必ず使用：**
- 本番サーバー
- 公開サービス
- 機密データ処理

**オプション：**
- 開発/テスト環境
- プライベートネットワークのみを使用するサーバー

ただし、可能であればすべてのインスタンスに適用しましょう。

### 10.3 追加のセキュリティ強化

Vultr Firewall以外にも：
- Fail2banのインストール（ブルートフォースをブロック）
- SSHキー認証の使用
- 定期的なセキュリティアップデート
- DDoS Protectionの有効化

複数のセキュリティ層が必要です。

### 10.4 参考資料

- [Vultr Firewall公式ドキュメント](https://docs.vultr.com/products/network/firewall)
- [Vultr APIドキュメント](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Vultr Firewallを活用すれば、クラウドサーバーを安全に保護できます。
無料で使いやすいです。
したがって、今すぐ設定してみましょう。
