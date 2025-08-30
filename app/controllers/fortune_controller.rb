class FortuneController < ApplicationController
  def index
    @remaining_count = FortuneNumber.remaining_count
  end

  def draw
    # รายการคำพรและข้อความโชคดีภาษาไทยและจีน
    fortunes_thai = [
      "โชคดีจะมาหาคุณในเร็วๆ นี้",
      "ความรักที่แท้จริงรออยู่ข้างหน้า",
      "การงานจะก้าวหน้าอย่างรวดเร็ว",
      "เงินทองจะไหลเข้ามาอย่างต่อเนื่อง",
      "สุขภาพแข็งแรงและมีความสุข",
      "ครอบครัวจะมีความสุขและความสามัคคี",
      "การเดินทางจะนำมาซึ่งโอกาสใหม่",
      "มิตรภาพใหม่จะเข้ามาในชีวิต",
      "ความสำเร็จจะมาพร้อมกับความอดทน",
      "วันนี้เป็นวันที่ดีสำหรับการเริ่มต้นใหม่",
      "ดวงดาวส่องแสงนำทางให้คุณ",
      "ความฝันจะกลายเป็นจริง",
      "การศึกษาจะประสบความสำเร็จ",
      "ธุรกิจจะเจริญรุ่งเรือง",
      "ความสงบสุขจะเติมเต็มใจคุณ"
    ]

    fortunes_chinese = [
      "鸿运当头，财源广进",
      "金玉满堂，富贵吉祥",
      "心想事成，万事如意",
      "恭喜发财，大吉大利",
      "年年有余，岁岁平安",
      "福如东海，寿比南山",
      "步步高升，前程似锦",
      "花开富贵，竹报平安",
      "龙凤呈祥，瑞气盈门",
      "吉星高照，好运连连",
      "家和万事兴，福满人间",
      "春风得意，马到成功",
      "财运亨通，事业有成",
      "平安健康，快乐永远",
      "紫气东来，祥瑞满堂"
    ]

    # สุ่มเลือกคำพร
    thai_fortune = fortunes_thai.sample
    chinese_fortune = fortunes_chinese.sample
    
    # สุ่มสีโชคดี
    lucky_colors = ["แดง", "ทอง", "เหลือง", "ม่วง", "ชมพู"]
    lucky_color = lucky_colors.sample
    
    # สุ่มตัวเลขโชคดี
    lucky_numbers = Array.new(6) { rand(1..49) }.uniq.sort
    
    # สุ่มหมายเลขของรางวัลจากฐานข้อมูลและลบทันที
    prize_number = FortuneNumber.draw_and_remove!
    remaining_count = FortuneNumber.remaining_count
    
    if prize_number
      render json: {
        thai_fortune: thai_fortune,
        chinese_fortune: chinese_fortune,
        lucky_color: lucky_color,
        lucky_numbers: lucky_numbers,
        prize_number: prize_number,
        remaining_prizes: remaining_count,
        success: true
      }
    else
      render json: {
        success: false,
        message: "ของรางวัลหมดแล้ว! กรุณารีเซ็ตระบบ",
        remaining_prizes: 0
      }
    end
  end

  # ฟังก์ชันรีเซ็ตหมายเลขทั้งหมด (สำหรับ admin)
  def reset_numbers
    FortuneNumber.reset_all!
    render json: {
      success: true,
      message: "รีเซ็ตหมายเลขเสร็จแล้ว! มีหมายเลข 100 ตัวให้สุ่มใหม่",
      remaining_prizes: FortuneNumber.remaining_count
    }
  end

  # ฟังก์ชันลบตัวเลขเฉพาะ
  def delete_number
    number = params[:number].to_i
    
    if number < 1 || number > 100
      render json: {
        success: false,
        message: "กรุณาใส่หมายเลขระหว่าง 1-100"
      }
      return
    end
    
    fortune_number = FortuneNumber.find_by(number: number)
    
    if fortune_number
      fortune_number.destroy!
      render json: {
        success: true,
        message: "ลบหมายเลข #{number} เรียบร้อยแล้ว",
        remaining_prizes: FortuneNumber.remaining_count
      }
    else
      render json: {
        success: false,
        message: "ไม่พบหมายเลข #{number} ในระบบ (อาจถูกลบไปแล้ว)"
      }
    end
  end

  # ฟังก์ชันเช็คสถานะหมายเลขที่เหลือ
  def status
    render json: {
      remaining_prizes: FortuneNumber.remaining_count,
      has_prizes: FortuneNumber.any_remaining?
    }
  end
end
