# 建立非特權容器

- 切換成「非 root」使用者
- OCP 權限控管較嚴格，務必將容器設定為「非 root」


## 建置 image
```bash
$ docker build --no-cache -t ubuntu:nanshan . 
```

## 運行容器
```bash
$ docker run -it --rm ubuntu:nanshan
```

### 進入容器後，驗證 nanshanuser 的密碼過期時間
> 預設密碼是永不過期
```bash
$ chage -l -i nanshanuser

Last password change                                    : 2023-09-13
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7
```