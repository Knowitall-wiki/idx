#!/bin/bash

# Docker 在 Ubuntu 24.04 上的安装脚本
# 基于实际操作步骤整理

# 确保脚本以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "此脚本需要 root 权限运行，请使用 sudo 执行"
    exit 1
fi

echo "===== 开始安装 Docker ====="

# 1. 解除系统服务的屏蔽（如果存在）
echo "正在解除系统服务的屏蔽..."
systemctl unmask docker.service 2>/dev/null || true
systemctl unmask docker.socket 2>/dev/null || true
systemctl unmask containerd 2>/dev/null || true

# 2. 更新系统并安装必要依赖
echo "正在更新系统并安装必要依赖..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# 3. 设置 Docker 存储库
echo "正在设置 Docker 存储库..."
# 创建目录
install -m 0755 -d /etc/apt/keyrings

# 下载并安装 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 设置适当的权限
chmod a+r /etc/apt/keyrings/docker.gpg

# 添加 Docker 存储库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. 更新包索引
echo "正在更新包索引..."
apt-get update

# 5. 安装 Docker 引擎
echo "正在安装 Docker 引擎..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. 启用 Docker 服务
echo "正在启用 Docker 服务..."
systemctl enable docker.service

# 7. 启动 Docker 服务
echo "正在启动 Docker 服务..."
systemctl start docker

# 8. 验证 Docker 服务状态
echo "Docker 服务状态:"
systemctl status docker --no-pager

# 9. 验证 Docker 安装
echo "正在验证 Docker 安装..."
docker run --rm hello-world || echo "无法运行 hello-world 容器，请检查 Docker 服务状态"

echo "===== Docker 安装完成 ====="
