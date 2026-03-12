---
theme: seriph
background: https://cover.sli.dev
title: Claude Codeを配ったのに使われない問題への処方箋
class: text-center
transition: slide-left
mdc: true
---

# Claude Codeを配ったのに<br>使われない問題への処方箋


<div class="abs-br m-6 text-sm opacity-75">
  2026-02-13 Claude Code Meetup Japan #3
</div>

---
layout: center
---

# Claude Codeでさえ手放しでは組織に普及しない

---
layout: center
---

# Claude Codeを組織展開するときのハードル
- 利用申請がめんどくさい
- 使ってたら秘匿情報が流出しそう
- そもそも使い方わからん
- 仕事で使える箇所が少ない

---
layout: center
---

# ハードルを取っ払うためにやったこと
- 最低限のセキュリティ担保
- 利用状況の可視化
- Claude Codeができることを増やす
- 利用申請する会を作る

---
layout: center
---

# 最低限のセキュリティ担保

---

# 利用者が必ず適用すべき設定を配布

- managed-settings.jsonを利用して配布
- このjsonに書いた設定は最も優先される
- 最近Claude for Teamsなどでも配布できるようになった(beta)

```bash
sudo mkdir -p "$(dirname /etc/claude-code/managed-settings.json)" \
  && sudo tee /etc/claude-code/managed-settings.json > /dev/null <<'EOF'
{
  "permissions": {
    "allow": [],
    "deny": [
      "Bash(git push:*)",
      "Bash(docker push:*)",
      "Read(.env*)"
    ]
  }
}
```

---
layout: center
---

# 利用状況の可視化

---

# Otelによる観測システムを運用する

<img src="./otel.png" class="w-full h-auto" style="filter: none; opacity: 1;" />

---
layout: center
---

# 観測環境は意外と簡単に構築できる
`make up` コマンド1つで前スライドの観測環境を構築可能


<img src="https://gh-card.dev/repos/ColeMurray/claude-code-otel.svg?fullname=" class="w-auto h-auto" style="filter: none; opacity: 1;" />

---
layout: center
---

# 利用状況の可視化 = 嫌なイメージがあるけど・・・
- ダッシュボードは全員見れるので誰がヘビーユーザーか分かる
- ナレッジ共有会が開かれるように

<img src="./fun-done.png" class="w-auto h-auto" style="filter: none; opacity: 1;" />

---
layout: center
---

# Claude Codeができることを増やす

---
layout: center
---

# Claude Codeを使った開発で大切なこと
- 出力の検証をできる
- 最新の情報にアクセスできる
- 作業をSkillとして再利用可能にする

こういうのは個人の資産に閉じがち

---
layout: center
---

# Claude Plugin Marketplaceを展開
- 業務で役立つSkillや内製MCPサーバーを簡単にインストールできるように

Plugin Marketplaceは簡単に作成 & 利用ができる

```json
// .claude-plugin/marketplace.json
{
  "name": "raccoon-claude-marketplace",
  // ~~~
  "plugins": [
    {
      "name": "change-manage-plugin",
      "source": "./plugins/change-manage-plugin",
      "description": "説明"
    },
  ]
}
```

```bash
# 1コマンドで導入可能
claude plugin marketplace add https://gitlab.com/~~/~~.git
```

---
layout: center
---

# その他細々としたこと

- 開発用社内DBに接続できるMCPサーバー
- 全リポジトリを横断検索可能なMCPサーバー
- BacklogにあるドキュメントをMarkdownとして参照できるように

---
layout: center
---

# 利用申請する会を作る

---
layout: center
---

- エンジニアの美徳の一つ「怠惰」
- 利用申請とセットアップがそもそも手間だった
- 申請からセットアップまでを一緒にやる会を設定
- **正直単純に利用者を増やすという点では１番効果があった**


---
layout: center
---

# 我々の仕事

## ❌️Claude Codeを使いこなす

## ⭕️良いプロダクトをユーザーに届ける

---
layout: center
---

## 社内のエンジニア全員がClaude Codeの情報を<br>キャッチアップしているわけではない

---

# これから導入する人/導入に苦戦する人に向けて

- managed-settings.jsonの配布
- 利用状況の可視化
- Claude Codeができることを増やす
- 利用申請のハードルを下げる

---
layout: image-right
image: https://github.com/taiga533/slides/blob/main/decks/20260312-claude-code/IMG_2674.jpg?raw=true
---

# 自己紹介

****

**名前**  
川崎 大河

**会社**  
ラクーンホールディングス株式会社

**役割**  
CTO室チームリーダー  
会社の技術的な仕組み作りが主な仕事

### X: kawasaki_533

<img src="./x-qr.png" class="w-32 h-auto pt-3">

