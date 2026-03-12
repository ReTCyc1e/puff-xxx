#!/bin/bash
set -e

# 启动 cron 前台进程（后台运行）
cron -f &

# 使用 Java 的真实绝对路径
exec sudo -u ctfuser /usr/local/openjdk-8/bin/java -jar /app/shirodemo-1.0-SNAPSHOT.jar
