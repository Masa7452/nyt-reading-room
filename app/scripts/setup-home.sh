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

# セクションヘッダーコンポーネントの生成
generate_section_header() {
    log "Generating SectionHeader component..."

    cat > "${SRC_DIR}/components/shared/SectionHeader.tsx" << 'EOL'
import React from 'react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { ChevronRight } from 'lucide-react';

interface SectionHeaderProps {
  title: string;
  href?: string;
}

export function SectionHeader({ title, href }: SectionHeaderProps) {
  return (
    <div className="flex items-center justify-between mb-6">
      <h2 className="text-2xl font-bold">{title}</h2>
      {href && (
        <Link href={href} passHref>
          <Button variant="ghost" className="flex items-center gap-1">
            View all
            <ChevronRight className="h-4 w-4" />
          </Button>
        </Link>
      )}
    </div>
  );
}
EOL

    success "SectionHeader component generated successfully"
}

# ベストセラーセクションの生成
generate_bestseller_section() {
    log "Generating BestsellerSection component..."

    cat > "${SRC_DIR}/components/home/BestsellerSection.tsx" << 'EOL'
import React from 'react';
import { SectionHeader } from '@/components/shared/SectionHeader';
import { BookGrid } from '@/components/books/BookGrid';
import { BookGridItem } from '@/types/book';

// モックデータ
const mockBestsellers: BookGridItem[] = [
  {
    id: 1,
    title: "The Bestseller",
    author: "Jane Smith",
    bookImageUrl: "/api/placeholder/400/600",
    rank: 1
  },
  {
    id: 2,
    title: "Another Hit",
    author: "John Doe",
    bookImageUrl: "/api/placeholder/400/600",
    rank: 2
  },
  // ... さらにモックデータを追加
];

export function BestsellerSection() {
  return (
    <section>
      <SectionHeader
        title="Current Bestsellers"
        href="/bestsellers"
      />
      <BookGrid books={mockBestsellers} showRank />
    </section>
  );
}
EOL

    success "BestsellerSection component generated successfully"
}

# 書評セクションの生成
generate_reviewed_books_section() {
    log "Generating ReviewedBooksSection component..."

    cat > "${SRC_DIR}/components/home/ReviewedBooksSection.tsx" << 'EOL'
import React from 'react';
import { SectionHeader } from '@/components/shared/SectionHeader';
import { Card, CardContent } from "@/components/ui/card";
import { BookGridItem } from '@/types/book';
import { Review } from '@/types/review';
import Link from 'next/link';
import Image from 'next/image';

interface ReviewedBook extends BookGridItem {
  latestReview: Review;
}

// モックデータ
const mockReviewedBooks: ReviewedBook[] = [
  {
    id: 1,
    title: "Reviewed Book",
    author: "Author Name",
    bookImageUrl: "/api/placeholder/400/600",
    latestReview: {
      id: 1,
      bookId: 1,
      reviewerName: "Critic Name",
      summary: "A compelling read that captures the imagination...",
      content: "Full review content...",
      publishDate: "2024-03-14",
      url: "#"
    }
  },
  // ... さらにモックデータを追加
];

export function ReviewedBooksSection() {
  return (
    <section>
      <SectionHeader
        title="Latest Reviews"
        href="/reviews"
      />
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {mockReviewedBooks.map((book) => (
          <Card key={book.id} className="overflow-hidden">
            <Link href={`/books/${book.id}`}>
              <CardContent className="p-6">
                <div className="flex gap-6">
                  <div className="relative w-32 aspect-[2/3] flex-shrink-0">
                    <Image
                      src={book.bookImageUrl}
                      alt={book.title}
                      fill
                      className="object-cover rounded"
                      sizes="(max-width: 768px) 100vw, 128px"
                    />
                  </div>
                  <div className="flex-grow">
                    <h3 className="font-semibold mb-1">{book.title}</h3>
                    <p className="text-sm text-gray-500 mb-4">{book.author}</p>
                    <p className="text-sm line-clamp-3">{book.latestReview.summary}</p>
                    <p className="text-sm text-gray-500 mt-2">
                      Reviewed by {book.latestReview.reviewerName}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Link>
          </Card>
        ))}
      </div>
    </section>
  );
}
EOL

    success "ReviewedBooksSection component generated successfully"
}

# 長期ベストセラーセクションの生成
generate_longterm_bestsellers_section() {
    log "Generating LongTermBestsellersSection component..."

    cat > "${SRC_DIR}/components/home/LongTermBestsellersSection.tsx" << 'EOL'
import React from 'react';
import { SectionHeader } from '@/components/shared/SectionHeader';
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import Link from 'next/link';
import Image from 'next/image';
import { Trophy } from 'lucide-react';

interface LongTermBestseller {
  id: number;
  title: string;
  author: string;
  bookImageUrl: string;
  weeksOnList: number;
  currentRank: number;
}

// モックデータ
const mockLongTermBestsellers: LongTermBestseller[] = [
  {
    id: 1,
    title: "Long-running Success",
    author: "Established Author",
    bookImageUrl: "/api/placeholder/400/600",
    weeksOnList: 52,
    currentRank: 3
  },
  // ... さらにモックデータを追加
];

export function LongTermBestsellersSection() {
  return (
    <section>
      <SectionHeader
        title="Long-term Bestsellers"
        href="/bestsellers/longterm"
      />
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {mockLongTermBestsellers.map((book) => (
          <Card key={book.id} className="overflow-hidden">
            <Link href={`/books/${book.id}`}>
              <CardContent className="p-6">
                <div className="flex gap-4">
                  <div className="relative w-24 aspect-[2/3] flex-shrink-0">
                    <Image
                      src={book.bookImageUrl}
                      alt={book.title}
                      fill
                      className="object-cover rounded"
                      sizes="(max-width: 768px) 100vw, 96px"
                    />
                  </div>
                  <div className="flex-grow">
                    <div className="flex items-center gap-2 mb-2">
                      <Trophy className="h-4 w-4 text-yellow-500" />
                      <Badge variant="secondary">
                        {book.weeksOnList} weeks
                      </Badge>
                    </div>
                    <h3 className="font-semibold mb-1">{book.title}</h3>
                    <p className="text-sm text-gray-500">{book.author}</p>
                    <p className="text-sm text-gray-500 mt-2">
                      Current rank: #{book.currentRank}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Link>
          </Card>
        ))}
      </div>
    </section>
  );
}
EOL

    success "LongTermBestsellersSection component generated successfully"
}

# ホームページの生成
generate_home_page() {
    log "Generating home page..."

    cat > "${SRC_DIR}/app/page.tsx" << 'EOL'
import { BestsellerSection } from "@/components/home/BestsellerSection";
import { ReviewedBooksSection } from "@/components/home/ReviewedBooksSection";
import { LongTermBestsellersSection } from "@/components/home/LongTermBestsellersSection";

export default function HomePage() {
  return (
    <div className="space-y-16">
      <BestsellerSection />
      <ReviewedBooksSection />
      <LongTermBestsellersSection />
    </div>
  );
}
EOL

    success "Home page generated successfully"
}

# メイン処理
main() {
    log "Starting home setup..."

    generate_section_header
    generate_bestseller_section
    generate_reviewed_books_section
    generate_longterm_bestsellers_section
    generate_home_page

    success "Home setup completed successfully"
}

main
