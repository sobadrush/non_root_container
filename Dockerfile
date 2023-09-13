FROM ubuntu:latest
ARG ap_user=nanshanuser
ARG ap_group=nanshangrp
ARG root_passwd=1qaz@WSX
ARG ap_user_password=1qaz@WSX
WORKDIR /app
# 設定 root 密碼(方便 su - 切換)
RUN echo "root:${root_passwd}" | chpasswd
# 建立 group & user
RUN groupadd ${ap_group} \
    && useradd -m -g ${ap_group} -s /bin/bash ${ap_user} \
    && echo "${ap_user}:$(openssl passwd -1 ${ap_user_password})" | chpasswd -e
# 將 ${ap_user} 加入 sudo list
RUN apt update && apt install sudo && echo "${ap_user} ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN chown -R ${ap_user}:${ap_group} /app
# 清理不需要的软件包和缓存
RUN apt clean && rm -rf /var/lib/apt/lists/*
# 切換容器角色
USER ${ap_user}
EXPOSE 22
ENTRYPOINT [ "/bin/bash" ]