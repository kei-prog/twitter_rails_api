# README

- Ruby version  
  3.2.1

- Docker ビルド

```
docker compose build

```

- データベース作成

```
docker compose run --rm api bin/rails db:create
```

- マイグレーション実行

```
docker compose run --rm api bin/rails db:migrate
```

- Rspec の実行

```
docker compose run --rm  api bundle exec rspec
```
