# NYT Reading Room - フロントエンド設計書

## 1. ディレクトリ構造

```
app/frontend/
├── src/
│   ├── app/
│   │   ├── layout.tsx                # ルートレイアウト
│   │   ├── page.tsx                  # トップページ
│   │   ├── loading.tsx               # ローディング
│   │   ├── error.tsx                 # エラーページ
│   │   ├── not-found.tsx            # 404ページ
│   │   ├── books/
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx         # 書籍詳細ページ
│   │   │   └── page.tsx             # 書籍一覧ページ
│   │   ├── categories/
│   │   │   ├── page.tsx             # カテゴリー一覧
│   │   │   └── [category]/
│   │   │       └── page.tsx         # カテゴリー別ページ
│   │   └── bestsellers/
│   │       └── history/
│   │           └── page.tsx         # 過去のベストセラー
│   ├── components/
│   │   ├── ui/                      # shadcn/uiコンポーネント
│   │   ├── layout/                  # レイアウトコンポーネント
│   │   ├── home/                    # トップページ用コンポーネント
│   │   ├── books/                   # 書籍関連コンポーネント
│   │   └── shared/                  # 共通コンポーネント
│   ├── lib/
│   │   ├── api/
│   │   │   └── mock/               # モックデータ
│   │   ├── hooks/                  # カスタムフック
│   │   └── utils/                  # ユーティリティ関数
│   └── types/                      # 型定義
└── public/
    └── images/                     # 静的画像
```

## 2. 型定義

```typescript
// types/book.ts
export interface Book {
  id: number;
  title: string;
  author: string;
  description: string;
  bookImageUrl: string;
  amazonUrl: string;
  publisher: string;
  isbn13: string;
  rank?: number;
  rankLastWeek?: number;
  weeksOnList?: number;
  reviews?: Review[];
}

// types/review.ts
export interface Review {
  id: number;
  bookId: number;
  reviewerName: string;
  summary: string;
  content: string;
  publishDate: string;
  url: string;
}

// types/category.ts
export interface Category {
  id: string;
  name: string;
  displayName: string;
  updateFrequency: 'WEEKLY' | 'MONTHLY';
  books: Book[];
}
```

## 3. ページ構成

### 3.1 トップページ

- 最新のベストセラー（上位 5 冊）
- 注目の書評本（3 冊）
- 長期ベストセラー（3 冊）
- カテゴリー別トップ 3
- ページネーション: 不要
- データ更新: ISR（6 時間）

### 3.2 カテゴリー一覧ページ

- 全カテゴリーのグリッド表示
- 各カテゴリーカード：
  - カテゴリー名
  - 最新の 1 位書籍表紙
  - 書籍数
  - 更新頻度
- データ更新: ISR（6 時間）

### 3.3 カテゴリー別ページ

- カテゴリートップ 5 の大きな表示
- 全書籍のグリッド表示
- ページネーション: 12 冊ごと
- データ更新: ISR（6 時間）

### 3.4 書籍詳細ページ

- 基本情報（タイトル、著者、画像等）
- ベストセラー情報（順位、期間等）
- 書評セクション
- Amazon 購入ボタン
- データ更新: ISR（24 時間）

### 3.5 過去のベストセラーページ

- 過去 5 年分のデータ表示
- フィルター機能
- 時系列順表示
- ページネーション: 20 件ごと
- データ更新: ISR（24 時間）

## 4. コンポーネント設計

### 4.1 共通コンポーネント

- Header: グローバルナビゲーション
- Footer: サイト情報
- LoadingSkeleton: ローディング表示
- ErrorMessage: エラー表示

### 4.2 書籍関連コンポーネント

- BookCard: 書籍情報カード
- BookGrid: 書籍グリッド表示
- BookDetail: 詳細情報表示
- ReviewList: 書評一覧

### 4.3 トップページコンポーネント

- BestsellerSection: ベストセラー表示
- ReviewedBooks: 書評本セクション
- LongTermBestsellers: 長期ベストセラー
- CategoryTopBooks: カテゴリー別トップ書籍

## 5. データフェッチング

### 5.1 基本戦略

- ページレベルでのサーバーサイドフェッチ
- ISR によるキャッシュ
- エラー時のフォールバック UI

### 5.2 キャッシュ戦略

- トップページ: 6 時間
- カテゴリーページ: 6 時間
- 書籍詳細: 24 時間
- 過去データ: 24 時間

## 6. エラーハンドリング

- ローディング状態の表示
- エラー時のフォールバック UI
- リトライ機能の実装
- 404 ページの提供

これでベースとなる設計は完了です。実装フェーズに移る前に、何か確認したい点はありますか？
