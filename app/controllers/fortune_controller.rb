class FortuneController < ApplicationController
  def index
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
    
    # สุ่มหมายเลขของรางวัล (1-50 ชิ้น)
    prize_number = rand(1..50)
    
    render json: {
      thai_fortune: thai_fortune,
      chinese_fortune: chinese_fortune,
      lucky_color: lucky_color,
      lucky_numbers: lucky_numbers,
      prize_number: prize_number
    }
  end
end
