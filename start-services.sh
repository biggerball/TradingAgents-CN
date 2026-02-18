#!/bin/bash
# 启动本地 MongoDB 和 Redis 服务

set -e

echo "正在启动 Redis..."
brew services start redis

echo "正在启动 MongoDB..."
brew services start mongodb/brew/mongodb-community

echo ""
echo "✓ 服务已启动"
echo "  - Redis: brew services start redis"
echo "  - MongoDB: brew services start mongodb/brew/mongodb-community"
echo ""
echo "查看服务状态: brew services list"
