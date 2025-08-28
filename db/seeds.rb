# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# สร้างหมายเลขโชค 1-100 ในฐานข้อมูล
puts "เริ่มต้นสร้างหมายเลขโชค 1-100..."

# ลบข้อมูลเก่าและสร้างใหม่
FortuneNumber.delete_all

# เติมหมายเลข 1-100
(1..100).each do |number|
  FortuneNumber.find_or_create_by!(number: number)
end

puts "สร้างหมายเลขโชคเสร็จแล้ว! จำนวนทั้งหมด: #{FortuneNumber.count} หมายเลข"
