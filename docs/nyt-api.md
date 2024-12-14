# NYT Books API 仕様

## 1. API 概要

### 1.1 ベース URL

```
https://api.nytimes.com/svc/books/v3
```

### 1.2 認証

- 認証方式: API Key 認証
- パラメータ名: `api-key`
- 場所: クエリパラメータ

### 1.3 提供サービス

1. ベストセラーリスト関連
   - リスト名取得
   - リストデータ取得
   - 履歴取得
   - 全リスト概要取得
   - トップ 5 概要取得
2. 書評サービス
   - 著者、ISBN、タイトルによる検索

## 2. エンドポイント詳細

### 2.1 リスト名取得

```
GET /lists/names.json
```

#### レスポンス例

```json
{
  "status": "OK",
  "copyright": "Copyright (c) 2019 The New York Times Company.  All Rights Reserved.",
  "num_results": 53,
  "results": [
    {
      "list_name": "Combined Print and E-Book Fiction",
      "display_name": "Combined Print & E-Book Fiction",
      "list_name_encoded": "combined-print-and-e-book-fiction",
      "oldest_published_date": "2011-02-13",
      "newest_published_date": "2016-03-20",
      "updated": "WEEKLY"
    }
  ]
}
```

### 2.2 ベストセラーリスト取得

```
GET /lists.json
```

#### クエリパラメータ

- `list` (必須): リスト名（例: "hardcover-fiction"）
- `bestsellers-date`: YYYY-MM-DD 形式
- `published-date`: YYYY-MM-DD 形式
- `offset`: 20 の倍数（ページネーション用）

#### レスポンス例

```json
{
  "status": "OK",
  "copyright": "Copyright (c) 2019 The New York Times Company.  All Rights Reserved.",
  "num_results": 1,
  "last_modified": "2016-03-11T13:09:01-05:00",
  "results": [
    {
      "list_name": "Hardcover Fiction",
      "display_name": "Hardcover Fiction",
      "bestsellers_date": "2016-03-05",
      "published_date": "2016-03-20",
      "rank": 5,
      "rank_last_week": 2,
      "weeks_on_list": 2,
      "amazon_product_url": "http://www.amazon.com/...",
      "book_details": [
        {
          "title": "EXAMPLE BOOK",
          "description": "Book description here",
          "contributor": "by Author Name",
          "author": "Author Name",
          "publisher": "Publisher Name",
          "primary_isbn13": "9780553391923",
          "primary_isbn10": "0553391925"
        }
      ]
    }
  ]
}
```

### 2.3 日付指定ベストセラー取得

```
GET /lists/{date}/{list}.json
```

#### パスパラメータ

- `date` (必須): YYYY-MM-DD 形式または"current"
- `list` (必須): リスト名

#### クエリパラメータ

- `offset`: 20 の倍数（ページネーション用）

#### レスポンス例

```json
{
  "status": "OK",
  "copyright": "Copyright (c) 2019 The New York Times Company.  All Rights Reserved.",
  "num_results": 15,
  "results": {
    "list_name": "Trade Fiction Paperback",
    "bestsellers_date": "2015-12-19",
    "published_date": "2016-01-03",
    "display_name": "Paperback Trade Fiction",
    "normal_list_ends_at": 10,
    "updated": "WEEKLY",
    "books": [
      {
        "rank": 1,
        "rank_last_week": 0,
        "weeks_on_list": 60,
        "primary_isbn13": "9780553418026",
        "publisher": "Publisher Name",
        "description": "Book description",
        "title": "Book Title",
        "author": "Author Name",
        "book_image": "http://example.com/image.jpg",
        "amazon_product_url": "http://www.amazon.com/..."
      }
    ]
  }
}
```

### 2.4 ベストセラー履歴取得

```
GET /lists/best-sellers/history.json
```

#### クエリパラメータ

- `age-group`: 対象年齢層
- `author`: 著者名
- `contributor`: 著者および貢献者
- `isbn`: 10 桁または 13 桁の ISBN
- `offset`: 20 の倍数
- `price`: 価格（小数点含む）
- `publisher`: 出版社名
- `title`: 書籍タイトル

#### レスポンス例

```json
{
  "status": "OK",
  "copyright": "Copyright (c) 2019 The New York Times Company.  All Rights Reserved.",
  "num_results": 28970,
  "results": [
    {
      "title": "Book Title",
      "description": "Book description",
      "author": "Author Name",
      "publisher": "Publisher Name",
      "ranks_history": [
        {
          "primary_isbn13": "9781591847939",
          "rank": 8,
          "list_name": "Business Books",
          "display_name": "Business",
          "published_date": "2016-03-13",
          "bestsellers_date": "2016-02-27",
          "weeks_on_list": 0
        }
      ]
    }
  ]
}
```

### 2.5 全リスト概要取得

```
GET /lists/full-overview.json
```

#### クエリパラメータ

- `published_date`: YYYY-MM-DD 形式

### 2.6 トップ 5 概要取得

```
GET /lists/overview.json
```

#### クエリパラメータ

- `published_date`: YYYY-MM-DD 形式

### 2.7 書評取得

```
GET /reviews.json
```

#### クエリパラメータ

- `isbn`: 10 桁または 13 桁の ISBN
- `title`: 書籍の完全なタイトル
- `author`: 著者の氏名（空白は%20 に変換）

#### レスポンス例

```json
{
  "status": "OK",
  "copyright": "Copyright (c) 2019 The New York Times Company.  All Rights Reserved.",
  "num_results": 2,
  "results": [
    {
      "url": "http://www.nytimes.com/example",
      "publication_dt": "2011-11-10",
      "byline": "REVIEWER NAME",
      "book_title": "Book Title",
      "book_author": "Author Name",
      "summary": "Review summary",
      "isbn13": ["9780307476463"]
    }
  ]
}
```

## 3. 利用上の注意点

### 3.1 レート制限

- API キーごとの制限あり
- エラー時は適切な待機時間を設定

### 3.2 エラーハンドリング

- 400: 無効なパラメータ
- 401: 認証エラー
- 429: レート制限超過
- 5xx: サーバーエラー

### 3.3 日付の扱い

- published_date は必ずしも実際の公開日と一致しない
- bestsellers_date は実際の販売データの集計期間
