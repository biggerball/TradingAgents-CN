#!/bin/bash
# 关闭本地 MongoDB 和 Redis 服务

set -e

echo "正在停止 Redis..."
brew services stop redis

echo "正在停止 MongoDB..."
brew services stop mongodb/brew/mongodb-community

echo ""
echo "✓ 服务已停止"
echo ""
echo "查看服务状态: brew services list"
