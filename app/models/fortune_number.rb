class FortuneNumber < ApplicationRecord
  validates :number, presence: true, uniqueness: true, 
            inclusion: { in: 1..100, message: "ต้องอยู่ระหว่าง 1-100" }

  # สุ่มเลือกหมายเลขหนึ่งตัวและลบออกจากฐานข้อมูล
  def self.draw_and_remove!
    # ใช้ transaction เพื่อความปลอดภัย
    transaction do
      # สุ่มเลือกหมายเลขหนึ่งตัว
      number_record = order("RANDOM()").first
      
      if number_record
        selected_number = number_record.number
        # ลบหมายเลขนั้นออกจากฐานข้อมูลทันที
        number_record.destroy!
        selected_number
      else
        # หากไม่มีหมายเลขเหลือ
        nil
      end
    end
  end

  # เช็คว่ายังมีหมายเลขเหลือไหม
  def self.any_remaining?
    exists?
  end

  # นับจำนวนหมายเลขที่เหลือ
  def self.remaining_count
    count
  end

  # รีเซ็ตหมายเลขทั้งหมด (เติมหมายเลข 1-100 ใหม่)
  def self.reset_all!
    transaction do
      # ลบหมายเลขเก่าทั้งหมด
      delete_all
      
      # เติมหมายเลข 1-100 ใหม่
      numbers = (1..100).map { |n| { number: n, created_at: Time.current, updated_at: Time.current } }
      insert_all(numbers)
    end
  end
end
