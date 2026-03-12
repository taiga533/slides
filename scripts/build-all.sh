#!/usr/bin/env bash
# 全スライドデッキをビルドするスクリプト
# 使用方法: REPO_NAME=<repo> bash scripts/build-all.sh

set -euo pipefail

REPO_NAME="${REPO_NAME:-slides}"
DECKS_DIR="decks"
DIST_DIR="dist"

echo "リポジトリ名: ${REPO_NAME}"
echo "デッキディレクトリ: ${DECKS_DIR}"

# dist ディレクトリをクリーン
rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"

# decks/ 配下のディレクトリを列挙してビルド
for deck_path in "${DECKS_DIR}"/*/; do
  deck_name="$(basename "${deck_path}")"
  slides_file="${deck_path}slides.md"

  if [[ ! -f "${slides_file}" ]]; then
    echo "警告: ${slides_file} が見つかりません。スキップします。"
    continue
  fi

  echo "ビルド中: ${deck_name}"
  npx slidev build "${slides_file}" \
    --base "/${REPO_NAME}/${deck_name}/" \
    --out "../../${DIST_DIR}/${deck_name}"
  echo "完了: ${deck_name}"
done

echo "全デッキのビルドが完了しました。"
