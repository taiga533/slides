# Slidev 複数スライド対応 + GitHub Pages デプロイ

## Context
現在は単一の `slides.md` をエントリポイントとするSlidevスターターテンプレートの状態。
これを複数のスライドデッキを管理できる構成にリストラクチャし、GitHub Actionsで自動ビルド → GitHub Pagesにデプロイできるようにする。

## 変更後のディレクトリ構成

```
slides/
├── .github/workflows/deploy.yml   # GitHub Actions
├── decks/                          # 全スライドデッキ格納
│   └── starter/                    # 既存slides.mdを移動（サンプル）
│       ├── slides.md
│       ├── components/
│       │   └── Counter.vue
│       ├── pages/
│       │   └── imported-slides.md
│       └── snippets/
│           └── external.ts
├── scripts/
│   ├── build-all.sh                # 全デッキビルド
│   └── generate-index.sh           # インデックスページ生成
├── package.json                    # scripts更新
├── .npmrc
├── .gitignore                      # 更新
└── README.md
```

**設計判断:** 共有コンポーネントは各デッキ内に配置する方式を採用。Slidevはエントリファイルからの相対パスで `components/` を解決するため、デッキごとに独立した構造にするのが最もシンプル。

## 実装手順

### Step 1: ディレクトリ作成 & ファイル移動
- `decks/starter/` を作成
- `slides.md` → `decks/starter/slides.md`
- `pages/` → `decks/starter/pages/`
- `snippets/` → `decks/starter/snippets/`
- `components/` → `decks/starter/components/`

### Step 2: ビルドスクリプト作成

**`scripts/build-all.sh`**
- `decks/` 配下のディレクトリを列挙
- 各デッキに対して `npx slidev build decks/<name>/slides.md --base /<repo>/<name>/ --out dist/<name>` を実行
- `REPO_NAME` 環境変数でベースパスを制御

**`scripts/generate-index.sh`**
- 各デッキの `slides.md` frontmatterから `title` を抽出
- リンク付きHTMLインデックスページを `dist/index.html` に生成

### Step 3: package.json 更新
```json
{
  "scripts": {
    "dev": "slidev --open",
    "build": "bash scripts/build-all.sh",
    "export": "slidev export"
  }
}
```

### Step 4: GitHub Actions ワークフロー作成

**`.github/workflows/deploy.yml`**
- トリガー: `push` to `main` + `workflow_dispatch`
- pnpm + Node 22 セットアップ
- `pnpm install --frozen-lockfile`
- `REPO_NAME=${{ github.event.repository.name }}` で全デッキビルド
- `actions/upload-pages-artifact@v3` + `actions/deploy-pages@v4` でデプロイ
- permissions: `pages: write`, `id-token: write`, `contents: read`

### Step 5: 不要ファイル削除 & .gitignore更新
- `netlify.toml` 削除
- `vercel.json` 削除
- `.gitignore` はそのまま（`dist` は既に含まれている）

## 新しいデッキの追加方法
`decks/<deck-name>/slides.md` を作成するだけで自動的にビルド対象になる。

## 検証方法
1. `REPO_NAME=slides pnpm build` でローカルビルドが成功すること
2. `dist/` 配下に `starter/` と `index.html` が生成されること
3. GitHub にプッシュ後、Actions が成功し GitHub Pages でアクセスできること

## 対象ファイル一覧
- **新規作成:** `.github/workflows/deploy.yml`, `scripts/build-all.sh`, `scripts/generate-index.sh`
- **移動:** `slides.md`, `components/`, `pages/`, `snippets/` → `decks/starter/` 配下
- **編集:** `package.json`, `.gitignore`
- **削除:** `netlify.toml`, `vercel.json`
