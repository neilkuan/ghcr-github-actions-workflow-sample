# ghcr-github-actions-workflow-sample

以 GitHub Actions 建置自訂 Nginx 映像，並推送至 GitHub Container Registry (GHCR) 的範例專案。映像支援多架構（AMD64 / ARM64），並提供可配置埠號與健康檢查端點。

## 專案說明

- **基礎映像**：`public.ecr.aws/nginx/nginx:stable`
- **自訂設定**：覆寫 `nginx.conf`、`conf.d/default.conf`，並以 `entrypoint.bash` 在啟動時依環境變數替換監聽埠與環境名稱
- **輸出**：映像推送至 `ghcr.io/neilkuan/nginx`，並建立多架構 manifest（`latest`、`latest-amd64`、`latest-arm64`）

## 專案結構

```
.
├── .github/workflows/build.yaml   # CI：建置並推送至 GHCR
├── Dockerfile                     # Nginx 映像定義
├── nginx.conf                     # Nginx 主設定
├── conf.d/default.conf           # 預設 server 與健康檢查
├── entrypoint.bash                # 啟動腳本（埠號替換 + 啟動 nginx）
└── README.md
```

## 環境變數

| 變數 | 說明 | 預設 |
|------|------|------|
| `NGINX_PORT` | Nginx 監聽埠 | `3000` |
| `ENV` | 環境名稱，顯示於 `/version` 端點 | `staging` |

## 健康檢查端點

以下路徑均回傳 `200` 與 `nginx OK`，可作為 liveness/readiness 使用：

- `/health_check`
- `/health`
- `/healthz`
- `/livez`
- `/up`

## 版本端點

`/version` 回傳目前環境名稱：

```bash
curl http://localhost:3000/version
# → <h1> This is production stack</h1>
```

## 本地建置與執行

```bash
# 建置
docker build -t nginx-sample .

# 執行（預設埠 3000）
docker run -p 3000:3000 nginx-sample

# 自訂埠
docker run -e NGINX_PORT=8080 -p 8080:8080 nginx-sample

# 自訂環境名稱
docker run -e ENV=staging -p 3000:3000 nginx-sample
```

## GitHub Actions 工作流程

- **檔案**：`.github/workflows/build.yaml`
- **觸發**：
  - 推送到 `main` 分支
  - 發佈 GitHub Release（`published`）
  - 每週一 00:22 UTC 排程
  - 手動 `workflow_dispatch`
- **步驟概覽**：
  1. **nginx-image-build-amd64**：在 `ubuntu-24.04` 建置並推送 AMD64 映像
  2. **nginx-image-build-arm64**：在 `ubuntu-24.04-arm` 建置並推送 ARM64 映像
  3. **create-manifest**：建立並推送多架構 manifest

- **Tag 策略**：
  - `main` push / 排程 / 手動：推送 `latest`、`latest-amd64`、`latest-arm64`
  - Release（例如 `v1.2.3`）：額外推送 `v1.2.3`、`v1.2.3-amd64`、`v1.2.3-arm64`

映像名稱由 workflow 的 `env.GHCR_REPO_URL` 決定（例如 `ghcr.io/neilkuan/nginx`）。

## 從 GHCR 拉取映像

```bash
# 登入（需 Personal Access Token 具 packages:read）
echo $GITHUB_TOKEN | docker login ghcr.io -u <username> --password-stdin

# 拉取並執行
docker pull ghcr.io/neilkuan/nginx:latest
docker run -p 3000:3000 ghcr.io/neilkuan/nginx:latest
```
