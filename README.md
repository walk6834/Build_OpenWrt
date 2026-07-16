# Build_OpenWrt

[![License](https://img.shields.io/github/license/walk6834/Build_OpenWrt?style=flat-square)](./LICENSE)
[![ImmortalWrt](https://img.shields.io/badge/ImmortalWrt-25.12-orange?style=flat-square&logo=openwrt)](https://github.com/immortalwrt/immortalwrt)
[![Build](https://img.shields.io/badge/build-Manual%20workflow-lightgrey?style=flat-square&logo=github-actions)](./.github/workflows/build-25.12-x86-64.yml)
[![Latest Release](https://img.shields.io/github/v/release/walk6834/Build_OpenWrt?style=flat-square)](https://github.com/walk6834/Build_OpenWrt/releases)
![Stars](https://img.shields.io/github/stars/walk6834/Build_OpenWrt?style=flat-square)

基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) `openwrt-25.12` 分支的 x86-64 软路由固件自定义构建仓库。

仓库本身**不包含 OpenWrt 源码**,只保存默认配置、自定义 feed、首次启动脚本与主题资源;构建时浅克隆上游源码,将 `x86-64/` 内容注入后再编译。生产构建运行在 GitHub Actions 的 `ubuntu-latest` runner 上,本地可在 Ubuntu / WSL 中复现。

---

## 快速开始(GitHub Actions)

1. 进入仓库 **Actions** → 选择 **Build OpenWrt 25.12** → **Run workflow**
2. 按需调整 6 个输入参数:

| 名称              | 类型    | 必填 | 默认值                    | 说明                             |
| ----------------- | ------- | ---- | ------------------------- | -------------------------------- |
| `repo_name`       | choice  | ✅   | `immortalwrt/immortalwrt` | 上游源码仓库                     |
| `repo_branch`     | string  | ✅   | `openwrt-25.12`           | 上游源码分支                     |
| `ip_address`      | string  |      | `192.168.10.1`            | 默认 LAN 口 IP                   |
| `pppoe_username`  | string  |      | ``                        | PPPoE 用户名                     |
| `pppoe_password`  | string  |      | ``                        | PPPoE 密码                       |
| `part_size`       | string  |      | 1024                      | rootfs 分区大小(MB)              |
| `upload_artifact` | boolean |      | `true`                    | 是否上传 GitHub Actions Artifact |
| `upload_release`  | boolean |      | `true`                    | 是否发布 GitHub Release          |

3. 等待 30–60 分钟,产物可通过以下两种方式获取:
   - **Artifact**:文件名格式 `<branch>-<YYYYMMDD>`,如 `openwrt-25.12-20260717`
   - **Release**:Tag 名称同 Artifact,Release 描述中展示源码、内核版本、默认 IP、默认密码

---

## 默认固件参数

| 项          | 默认值                                      |
| ----------- | ------------------------------------------- |
| 目标平台    | x86-64 generic                              |
| 上游源码    | `immortalwrt/immortalwrt` @ `openwrt-25.12` |
| Rootfs 分区 | 1024 MB                                     |
| LAN IP      | `192.168.10.1`                              |
| Root 密码   | `password`                                  |
| 时区        | `Asia/Shanghai` (`CST-8`)                   |
| LuCI 主题   | Argon(自定义背景图 `images/bg1.jpg`)        |
| ttyd        | root 免登录(`/bin/login -f root`)           |

完整 338 行配置见 [`x86-64/default.config`](./x86-64/default.config)。

---

## ⚠️ 安全提醒

- 默认 **root 密码** `password` 是公开配置,**首次登录后必须立即修改**
- **ttyd** 默认配置为 root 免登录,**禁止在不可信网络或公网中暴露 ttyd 服务**
- 部署到生产环境前,请审计 [`x86-64/files/etc/uci-defaults/99-custom-settings.sh`](./x86-64/files/etc/uci-defaults/99-custom-settings.sh) 中的所有占位项

---

## 本地构建(Ubuntu / WSL)

> 需要 `sudo` 权限、可访问 GitHub、≥ 30 GB 可用磁盘空间。

```bash
# 1. 安装编译依赖(Ubuntu)
sudo apt update
sudo bash scripts/init-env.sh

# 2. 从零构建(首次会浅克隆上游源码)
./build.sh

# 3. 增量构建(复用已有 openwrt/ 目录)
./rebuild.sh
```

构建产物输出到 `uploads/` 目录,包含 `.config` 与所有 `*wrt*.img.gz` 固件镜像。

---

## License

本项目采用 [Apache License 2.0](./LICENSE)。
