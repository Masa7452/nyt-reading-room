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

# ディレクトリの存在確認
if [ ! -d "$FRONTEND_DIR" ]; then
    log "Creating frontend directory..."
    mkdir -p "$FRONTEND_DIR"
fi

# 型定義ファイルの生成
generate_types() {
    log "Generating type definitions..."

    # types/book.ts
    cat > "${SRC_DIR}/types/book.ts" << 'EOL'
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

export type BookGridItem = Pick<Book, 'id' | 'title' | 'author' | 'bookImageUrl' | 'rank'>;
EOL

    # types/review.ts
    cat > "${SRC_DIR}/types/review.ts" << 'EOL'
export interface Review {
  id: number;
  bookId: number;
  reviewerName: string;
  summary: string;
  content: string;
  publishDate: string;
  url: string;
}
EOL

    # types/category.ts
    cat > "${SRC_DIR}/types/category.ts" << 'EOL'
export interface Category {
  id: string;
  name: string;
  displayName: string;
  updateFrequency: "WEEKLY" | "MONTHLY";
  books: Book[];
}
EOL

    success "Type definitions generated successfully"
}

# レイアウトコンポーネントの生成
generate_layout_components() {
    log "Generating layout components..."

    # components/layout/Header.tsx
    cat > "${SRC_DIR}/components/layout/Header.tsx" << 'EOL'
import React from 'react';
import Link from 'next/link';
import { Home, Book, List } from 'lucide-react';
import { Button } from '@/components/ui/button';

export function Header() {
  return (
    <header className="border-b">
      <div className="container mx-auto px-4 py-4">
        <nav className="flex items-center justify-between">
          <Link href="/" className="flex items-center space-x-2">
            <Book className="h-6 w-6" />
            <span className="text-xl font-bold">NYT Reading Room</span>
          </Link>

          <div className="flex items-center space-x-4">
            <Link href="/" passHref>
              <Button variant="ghost" size="sm">
                <Home className="h-4 w-4 mr-2" />
                Home
              </Button>
            </Link>
            <Link href="/categories" passHref>
              <Button variant="ghost" size="sm">
                <List className="h-4 w-4 mr-2" />
                Categories
              </Button>
            </Link>
            <Link href="/bestsellers/history" passHref>
              <Button variant="ghost" size="sm">
                <Book className="h-4 w-4 mr-2" />
                History
              </Button>
            </Link>
          </div>
        </nav>
      </div>
    </header>
  );
}
EOL

    # components/layout/Footer.tsx
    cat > "${SRC_DIR}/components/layout/Footer.tsx" << 'EOL'
import React from 'react';
import { Github } from 'lucide-react';

export function Footer() {
  return (
    <footer className="border-t">
      <div className="container mx-auto px-4 py-8">
        <div className="flex flex-col items-center justify-center space-y-4">
          <div className="flex items-center space-x-4">
            <a href="https://github.com" target="_blank" rel="noopener noreferrer"
               className="text-gray-500 hover:text-gray-700">
              <Github className="h-6 w-6" />
            </a>
          </div>
          <p className="text-sm text-gray-500">
            © {new Date().getFullYear()} NYT Reading Room. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
EOL

    success "Layout components generated successfully"
}

# 共通UIコンポーネントの生成
generate_shared_components() {
    log "Generating shared components..."

    # components/shared/LoadingSkeleton.tsx
    cat > "${SRC_DIR}/components/shared/LoadingSkeleton.tsx" << 'EOL'
import React from 'react';
import { Skeleton } from "@/components/ui/skeleton";

export function LoadingSkeleton() {
  return (
    <div className="space-y-4">
      <div className="space-y-2">
        <Skeleton className="h-4 w-[250px]" />
        <Skeleton className="h-4 w-[200px]" />
      </div>
      <div className="space-y-2">
        <Skeleton className="h-4 w-[250px]" />
        <Skeleton className="h-4 w-[200px]" />
      </div>
      <div className="space-y-2">
        <Skeleton className="h-4 w-[250px]" />
        <Skeleton className="h-4 w-[200px]" />
      </div>
    </div>
  );
}
EOL

    success "Shared components generated successfully"
}

# ルートレイアウトの生成
generate_root_layout() {
    log "Generating root layout..."

    cat > "${SRC_DIR}/app/layout.tsx" << 'EOL'
import { Inter } from "next/font/google";
import { Header } from "@/components/layout/Header";
import { Footer } from "@/components/layout/Footer";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "NYT Reading Room",
  description: "Discover the best books with New York Times bestseller lists and reviews",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <div className="min-h-screen flex flex-col">
          <Header />
          <main className="flex-grow container mx-auto px-4 py-8">
            {children}
          </main>
          <Footer />
        </div>
      </body>
    </html>
  );
}
EOL

    success "Root layout generated successfully"
}

# メイン処理
main() {
    log "Starting core setup..."

    generate_types
    generate_layout_components
    generate_shared_components
    generate_root_layout

    success "Core setup completed successfully"
}

main
