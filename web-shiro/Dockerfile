FROM openjdk:8-slim-bullseye

# 使用国内镜像源加速构建
RUN sed -i 's@//.*deb.debian.org@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list && \
    sed -i 's@//.*security.debian.org@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list

# 安装必要工具：sudo + cron（关键！）
RUN apt-get update && \
    apt-get install -y \
        python3 \
        net-tools \
        curl \
        wget \
        sudo \
        cron \
    && rm -rf /var/lib/apt/lists/*

# 创建普通用户 ctfuser
RUN groupadd -g 1000 ctfuser && \
    useradd -u 1000 -g ctfuser -m -s /bin/bash ctfuser

# 创建应用目录并复制 JAR
RUN mkdir -p /app && chown ctfuser:ctfuser /app
COPY ./src/shirodemo-1.0-SNAPSHOT.jar /app/
RUN chown ctfuser:ctfuser /app/shirodemo-1.0-SNAPSHOT.jar

# ========== 故意制造两个漏洞 ==========
# 漏洞 1：sudo 免密提权（用于获取 root）
RUN echo 'ctfuser ALL=(ALL) NOPASSWD: /bin/bash' >> /etc/sudoers

# 漏洞 2：创建一个全局可写的 cron 目录（模拟配置错误）
# 攻击者可在此放置 .sh 脚本，cron 会以 root 身份执行！
RUN mkdir -p /etc/cron.d/ && chmod 777 /etc/cron.d/

# 启动 cron 服务（必须！否则计划任务不运行）
RUN systemctl enable cron || true  # systemd 在容器中通常不可用，改用直接启动


# 在切换用户前完成所有 root 操作
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh    # ← 仍以 root 身份执行，成功！


WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
