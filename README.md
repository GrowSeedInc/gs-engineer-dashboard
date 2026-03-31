# gs-engineer-dashboard

エンジニア個人の売上推移・還元率・受注契約・稼働時間を一元管理するダッシュボードアプリ。

---

## 前提条件

以下がインストールされていること。

- [Docker](https://docs.docker.com/get-docker/) (v24 以上推奨)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2 以上)

---

## セットアップ手順

### 1. リポジトリをクローン

```bash
git clone https://github.com/GrowSeedInc/gs-engineer-dashboard.git
cd gs-engineer-dashboard
```

### 2. コンテナをビルド・起動

```bash
docker compose up --build -d
```

初回はイメージのビルドに数分かかります。

### 3. データベースを初期化

```bash
docker compose exec backend bundle exec rails db:create db:migrate db:seed
```

---

## アクセス

| サービス | URL |
|---|---|
| Frontend | http://localhost:5173 |
| Backend API | http://localhost:3000 |

---

## コンテナの停止

```bash
docker compose down
```

DBのデータも含めて完全に削除する場合:

```bash
docker compose down -v
```
