#!/bin/bash
set -e

REPO="git@github.com:TYchui516/OneWorldTravel.git"

echo "🚨 注意：這會刪除整個 Git 歷史，僅保留目前檔案。"
read -p "確認要繼續嗎？(y/n) " confirm
if [ "$confirm" != "y" ]; then
  echo "❌ 已取消"
  exit 1
fi

echo "🧹 移除舊的 .git 資料夾..."
rm -rf .git

echo "🔧 初始化新的 Git repo..."
git init
git branch -M main
git remote add origin $REPO

echo "⚙️ 建立 .gitignore（如果尚未存在）..."
if [ ! -f ".gitignore" ]; then
  echo ".env" > .gitignore
  echo "✅ 已建立新的 .gitignore 並加入 .env"
else
  if ! grep -q "^.env$" .gitignore; then
    echo ".env" >> .gitignore
    echo "✅ 已將 .env 加入現有的 .gitignore"
  fi
fi

echo "🔑 建立 .env 範例檔..."
if [ ! -f ".env" ]; then
  cat > .env <<EOL
# 在這裡放你的 API key
OPENAI_API_KEY=sk-your_new_key_here
EOL
  echo "✅ 已建立 .env 檔 (請記得手動填入新的 API Key)"
else
  echo "⚠️ 已經存在 .env 檔，未覆蓋"
fi

echo "➕ 新增所有檔案..."
git add .

echo "💾 建立乾淨初始 commit..."
git commit -m "Clean repo: remove secrets, reset history, add .gitignore/.env setup"

echo "🚀 強制推送到 GitHub..."
git push origin main --force

echo "✅ 推送完成！你的 GitHub repo 已被清理並更新"
echo "⚠️ 請登入 https://platform.openai.com/account/api-keys"
echo "⚠️ 馬上刪除舊的 OpenAI API Key 並建立新的，填到 .env 檔中"#!/bin/bash
set -e

REPO="git@github.com:TYchui516/OneWorldTravel.git"

echo "🚨 注意：這將刪除整個 Git 歷史，僅保留當前檔案。"
read -p "確認要繼續嗎？(y/n) " confirm
if [ "$confirm" != "y" ]; then
  echo "❌ 已取消"
  exit 1
fi

echo "🧹 移除現有的 .git 資料夾..."
rm -rf .git

echo "🔧 初始化新的 git repo..."
git init
git branch -M main
git remote add origin $REPO

echo "➕ 新增所有檔案..."
git add .

echo "💾 建立乾淨的初始 commit..."
git commit -m "Clean repo: remove secrets and reset history"

echo "🚀 強制推送到 GitHub..."
git push origin main --force

echo "✅ 完成！GitHub 上的歷史已經被重置。"
echo "⚠️ 記得到 https://platform.openai.com/account/api-keys 刪掉舊的 OpenAI API Key 並換成新的。"

