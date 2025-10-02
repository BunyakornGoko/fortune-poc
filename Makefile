# Makefile for Fortune POC Rails Application
# ใช้สำหรับจัดการฐานข้อมูล และ commands ต่างๆ

.PHONY: help db-reset db-drop db-create db-migrate db-seed db-setup test-reset dev server

# แสดงคำสั่งที่ใช้ได้
help:
	@echo "คำสั่งที่ใช้ได้:"
	@echo "  make db-reset     - รีเซ็ตฐานข้อมูลทั้งหมด (drop, create, migrate, seed)"
	@echo "  make db-drop      - ลบฐานข้อมูล"
	@echo "  make db-create    - สร้างฐานข้อมูล"
	@echo "  make db-migrate   - รัน migrations"
	@echo "  make db-seed      - เติมข้อมูลเริ่มต้น"
	@echo "  make db-setup     - ตั้งค่าฐานข้อมูลใหม่ (create + migrate + seed)"
	@echo "  make test-reset   - รีเซ็ตฐานข้อมูล test"
	@echo "  make dev          - รันเซิร์ฟเวอร์ development"
	@echo "  make server       - รันเซิร์ฟเวอร์ production"
	@echo "  make help         - แสดงคำสั่งนี้"

up:
	docker compose up -d
	
down:
	docker compose down

down-up-db:
	docker compose down
	docker compose up -d
# รีเซ็ตฐานข้อมูลทั้งหมด
db-reset:
	@echo "🔄 กำลังรีเซ็ตฐานข้อมูล..."
	bundle exec rails db:drop
	bundle exec rails db:create
	bundle exec rails db:migrate
	bundle exec rails db:seed
	@echo "✅ รีเซ็ตฐานข้อมูลเสร็จแล้ว!"

# ลบฐานข้อมูล
db-drop:
	@echo "🗑️  กำลังลบฐานข้อมูล..."
	bundle exec rails db:drop
	@echo "✅ ลบฐานข้อมูลเสร็จแล้ว!"

# สร้างฐานข้อมูล
db-create:
	@echo "🏗️  กำลังสร้างฐานข้อมูล..."
	bundle exec rails db:create
	@echo "✅ สร้างฐานข้อมูลเสร็จแล้ว!"

# รัน migrations
db-migrate:
	@echo "📦 กำลังรัน migrations..."
	bundle exec rails db:migrate
	@echo "✅ รัน migrations เสร็จแล้ว!"

# เติมข้อมูลเริ่มต้น
db-seed:
	@echo "🌱 กำลังเติมข้อมูลเริ่มต้น..."
	bundle exec rails db:seed
	@echo "✅ เติมข้อมูลเริ่มต้นเสร็จแล้ว!"

# ตั้งค่าฐานข้อมูลใหม่
db-setup:
	@echo "⚙️  กำลังตั้งค่าฐานข้อมูลใหม่..."
	bundle exec rails db:setup
	@echo "✅ ตั้งค่าฐานข้อมูลเสร็จแล้ว!"

# รีเซ็ตฐานข้อมูล test
test-reset:
	@echo "🧪 กำลังรีเซ็ตฐานข้อมูล test..."
	RAILS_ENV=test bundle exec rails db:drop
	RAILS_ENV=test bundle exec rails db:create
	RAILS_ENV=test bundle exec rails db:migrate
	@echo "✅ รีเซ็ตฐานข้อมูล test เสร็จแล้ว!"

# รันเซิร์ฟเวอร์ development
dev:
	@echo "🚀 กำลังรันเซิร์ฟเวอร์ development..."
	bin/dev

# รันเซิร์ฟเวอร์ production
server:
	@echo "🚀 กำลังรันเซิร์ฟเวอร์ production..."
	bundle exec rails server

# คำสั่งเสริม - ติดตั้ง dependencies
install:
	@echo "📦 กำลังติดตั้ง dependencies..."
	bundle install
	@echo "✅ ติดตั้ง dependencies เสร็จแล้ว!"

# คำสั่งเสริม - รัน tests
test:
	@echo "🧪 กำลังรัน tests..."
	bundle exec rspec
	@echo "✅ รัน tests เสร็จแล้ว!"

# คำสั่งเสริม - ทำความสะอาด logs
clean:
	@echo "🧹 กำลังทำความสะอาด logs..."
	rm -f log/*.log
	@echo "✅ ทำความสะอาด logs เสร็จแล้ว!"

# คำสั่งรวม - เตรียมพร้อมสำหรับ development
prepare:
	@echo "🔧 กำลังเตรียมพร้อมสำหรับ development..."
	make install
	make db-reset
	@echo "✅ เตรียมพร้อมเสร็จแล้ว! ใช้ 'make dev' เพื่อรันเซิร์ฟเวอร์"

run:
	bin/dev