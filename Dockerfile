FROM ubuntu:latest
# ARG等號右方為預設值
ARG ap_user
ARG ap_group
ARG root_passwd
ARG ap_user_password

# 使用 ENV 抓取 ARG
# ARG 的值：透過 build.sh --build-arg 中傳入
ENV ap_user=${ap_user:-nanshanuser}
ENV ap_group=${ap_group:-nanshangrp}
ENV root_passwd=${root_passwd:-1qaz@WSX}
ENV ap_user_password=${ap_user_password:-1qaz@WSX}

WORKDIR /app
# 設定 root 密碼(方便 su - 切換)
RUN echo "root:${root_passwd}" | chpasswd
# 建立 group & user

RUN groupadd ${ap_group} \
    && useradd -m -g ${ap_group} -s /bin/bash ${ap_user} \
    && echo "${ap_user}:$(openssl passwd -1 ${ap_user_password})" | chpasswd -e

RUN chown -R ${ap_user}:${ap_group} /app

# 將 ${ap_user} 加入 sudo list
RUN apt update && apt install sudo \
    && echo "${ap_user} ALL=(ALL:ALL) ALL" >> /etc/sudoers

# 清理不需要的软件包和缓存
RUN apt clean && rm -rf /var/lib/apt/lists/*

# 切換容器角色
USER ${ap_user}
EXPOSE 22
ENTRYPOINT [ "/bin/bash" ]