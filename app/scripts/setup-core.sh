#!/bin/bash

# エラーハンドリングの設定
set -e

# 色の定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# ログ関数
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# 成功ログ関数
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# メインディレクトリの設定
FRONTEND_DIR="app/frontend"
SRC_DIR="${FRONTEND_DIR}/src"

# 書籍カードコンポーネントの生成
generate_book_card() {
    log "Generating BookCard component..."

    cat > "${SRC_DIR}/components/books/BookCard.tsx" << 'EOL'
import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { BookGridItem } from '@/types/book';

interface BookCardProps {
  book: BookGridItem;
  showRank?: boolean;
}

export function BookCard({ book, showRank = false }: BookCardProps) {
  return (
    <Card className="overflow-hidden h-full transition-transform hover:scale-[1.02]">
      <Link href={`/books/${book.id}`}>
        <CardContent className="p-0 relative">
          {showRank && book.rank && (
            <Badge className="absolute top-2 right-2 z-10">
              #{book.rank}
            </Badge>
          )}
          <div className="relative aspect-[2/3] w-full">
            <Image
              src={book.bookImageUrl}
              alt={book.title}
              fill
              className="object-cover"
              sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
            />
          </div>
        </CardContent>
        <CardFooter className="flex flex-col items-start gap-2 p-4">
          <h3 className="font-semibold line-clamp-2">{book.title}</h3>
          <p className="text-sm text-gray-500">{book.author}</p>
        </CardFooter>
      </Link>
    </Card>
  );
}
EOL

    success "BookCard component generated successfully"
}

# 書籍グリッドコンポーネントの生成
generate_book_grid() {
    log "Generating BookGrid component..."

    cat > "${SRC_DIR}/components/books/BookGrid.tsx" << 'EOL'
import React from 'react';
import { BookCard } from './BookCard';
import { BookGridItem } from '@/types/book';

interface BookGridProps {
  books: BookGridItem[];
  showRank?: boolean;
}

export function BookGrid({ books, showRank = false }: BookGridProps) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {books.map((book) => (
        <BookCard key={book.id} book={book} showRank={showRank} />
      ))}
    </div>
  );
}
EOL

    success "BookGrid component generated successfully"
}

# 書籍詳細コンポーネントの生成
generate_book_detail() {
    log "Generating BookDetail component..."

    cat > "${SRC_DIR}/components/books/BookDetail.tsx" << 'EOL'
import React from 'react';
import Image from 'next/image';
import { ExternalLink } from 'lucide-react';
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Book } from '@/types/book';

interface BookDetailProps {
  book: Book;
}

export function BookDetail({ book }: BookDetailProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
      <div className="relative aspect-[2/3] w-full max-w-md mx-auto">
        <Image
          src={book.bookImageUrl}
          alt={book.title}
          fill
          className="object-cover rounded-lg shadow-lg"
          sizes="(max-width: 768px) 100vw, 50vw"
          priority
        />
      </div>

      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold mb-2">{book.title}</h1>
          <p className="text-xl text-gray-600 mb-4">by {book.author}</p>
          {book.rank && (
            <Badge variant="secondary" className="mb-4">
              Current Rank: #{book.rank}
            </Badge>
          )}
        </div>

        <Card>
          <CardContent className="space-y-4 pt-6">
            <div>
              <h2 className="font-semibold mb-2">Description</h2>
              <p className="text-gray-600">{book.description}</p>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <h2 className="font-semibold mb-2">Publisher</h2>
                <p className="text-gray-600">{book.publisher}</p>
              </div>
              <div>
                <h2 className="font-semibold mb-2">ISBN-13</h2>
                <p className="text-gray-600">{book.isbn13}</p>
              </div>
            </div>

            {book.weeksOnList && (
              <div>
                <h2 className="font-semibold mb-2">Bestseller Status</h2>
                <p className="text-gray-600">
                  {book.weeksOnList} weeks on the bestseller list
                  {book.rankLastWeek && (
                    <span className="block">
                      Last week's rank: #{book.rankLastWeek}
                    </span>
                  )}
                </p>
              </div>
            )}
          </CardContent>
        </Card>

        <Button className="w-full" asChild>
          <a href={book.amazonUrl} target="_blank" rel="noopener noreferrer">
            Buy on Amazon
            <ExternalLink className="ml-2 h-4 w-4" />
          </a>
        </Button>
      </div>
    </div>
  );
}
EOL

    success "BookDetail component generated successfully"
}

# 書籍ページの生成
generate_book_pages() {
    log "Generating book pages..."

    # 書籍一覧ページ
    cat > "${SRC_DIR}/app/books/page.tsx" << 'EOL'
import { BookGrid } from "@/components/books/BookGrid";

// モックデータ
const mockBooks = [
  {
    id: 1,
    title: "The Example Book",
    author: "John Doe",
    bookImageUrl: "/api/placeholder/400/600",
    rank: 1
  },
  // ... 他のモックデータ
];

export default function BooksPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">All Books</h1>
      <BookGrid books={mockBooks} showRank />
    </div>
  );
}
EOL

    # 書籍詳細ページ
    cat > "${SRC_DIR}/app/books/[id]/page.tsx" << 'EOL'
import { BookDetail } from "@/components/books/BookDetail";

// モックデータ
const mockBook = {
  id: 1,
  title: "The Example Book",
  author: "John Doe",
  description: "This is an example book description that shows how the layout would look with real content. It should be long enough to demonstrate text wrapping.",
  bookImageUrl: "/api/placeholder/400/600",
  amazonUrl: "https://amazon.com",
  publisher: "Example Publishing",
  isbn13: "9781234567890",
  rank: 1,
  rankLastWeek: 2,
  weeksOnList: 5
};

export default function BookDetailPage({ params }: { params: { id: string } }) {
  return (
    <div className="max-w-6xl mx-auto">
      <BookDetail book={mockBook} />
    </div>
  );
}
EOL

    success "Book pages generated successfully"
}

# メイン処理
main() {
    log "Starting books setup..."

    generate_book_card
    generate_book_grid
    generate_book_detail
    generate_book_pages

    success "Books setup completed successfully"
}

main
