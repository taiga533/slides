#!/usr/bin/env bash
# インデックスページを生成するスクリプト
# 各デッキの slides.md frontmatter から title を抽出してリンク付きHTMLを生成する

set -euo pipefail

REPO_NAME="${REPO_NAME:-slides}"
DECKS_DIR="decks"
DIST_DIR="dist"

OUTPUT_FILE="${DIST_DIR}/index.html"

echo "インデックスページを生成中..."

# HTMLヘッダー出力
cat > "${OUTPUT_FILE}" << 'HEADER'
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>スライド一覧</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
      background: #f5f5f5;
    }
    h1 {
      color: #333;
      border-bottom: 2px solid #4EC5D4;
      padding-bottom: 0.5rem;
    }
    ul {
      list-style: none;
      padding: 0;
    }
    li {
      margin: 1rem 0;
    }
    a {
      display: block;
      padding: 1rem 1.5rem;
      background: white;
      border-radius: 8px;
      text-decoration: none;
      color: #2B90B6;
      font-size: 1.1rem;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      transition: box-shadow 0.2s;
    }
    a:hover {
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
    .deck-name {
      font-size: 0.8rem;
      color: #999;
      margin-top: 0.25rem;
    }
  </style>
</head>
<body>
  <h1>スライド一覧</h1>
  <ul>
HEADER

# 各デッキのエントリを追加
for deck_path in "${DECKS_DIR}"/*/; do
  deck_name="$(basename "${deck_path}")"
  slides_file="${deck_path}slides.md"

  if [[ ! -f "${slides_file}" ]]; then
    continue
  fi

  # frontmatter から title を抽出（--- で囲まれた範囲の title: を取得）
  title="$(awk '/^---$/{if(found) exit; found=1; next} found && /^title:/{sub(/^title:\s*/, ""); print; exit}' "${slides_file}")"
  if [[ -z "${title}" ]]; then
    title="${deck_name}"
  fi

  cat >> "${OUTPUT_FILE}" << ENTRY
    <li>
      <a href="/${REPO_NAME}/${deck_name}/">
        ${title}
        <div class="deck-name">${deck_name}</div>
      </a>
    </li>
ENTRY
done

# HTMLフッター出力
cat >> "${OUTPUT_FILE}" << 'FOOTER'
  </ul>
</body>
</html>
FOOTER

echo "インデックスページを生成しました: ${OUTPUT_FILE}"
