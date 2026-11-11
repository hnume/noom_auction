module AuctionsHelper
  THAI_MONTHS = %w[ม.ค. ก.พ. มี.ค. เม.ย. พ.ค. มิ.ย. ก.ค. ส.ค. ก.ย. ต.ค. พ.ย. ธ.ค.].freeze

  # Real product photos from Wikimedia Commons, used under each file's license.
  PHOTO_CREDITS = {
    "Nikon_FM2_in_black.jpg" => { by: "Mariom990", license: "CC BY-SA 4.0" },
    "Vintage_Seiko_5_Men's_Automatic_(Self-Winding)_Wristwatch,_Day-Date,_Made_In_Japan_(15871131175).jpg" => { by: "Joe Haupt", license: "CC BY-SA 2.0" },
    "Yamaha_F310.jpg" => { by: "Glama1", license: "CC BY-SA 4.0" },
    "Trek_7200_(2008).JPG" => { by: "Yohan euan o4", license: "CC BY-SA 3.0" },
    "Vinilos_distintos_tamaños.jpg" => { by: "Banfield", license: "CC BY-SA 3.0" },
    "Thai_buddhist_amulets.jpg" => { by: "Mattes", license: "Public domain" },
    "IPad_Air_4.png" => { by: "ajay_suresh", license: "CC BY-SA 2.0" },
    "Antique_table_(26274842252).jpg" => { by: "Flickr upload", license: "CC BY 2.0" },
    "Winter_Landscape_with_Brabrand_Church.jpg" => { by: "Christian David Gebauer", license: "Public domain" },
    "Słuchawki_referencyjne_K-701_firmy_AKG.jpg" => { by: "muzyczny.pl", license: "CC BY-SA 4.0" },
    "M3_Macbook_Pro_14_inch_Space_Grey_model_(cropped).jpg" => { by: "Kyu3a", license: "CC BY-SA 4.0" },
    "Royal_Enfield_Bullet_500_-_2002_model.jpg" => { by: "Samihasib", license: "CC BY-SA 3.0" }
  }.freeze

  # Resized image served by Wikimedia (stable redirect to the current file).
  def photo_url(file, width: 640)
    "https://commons.wikimedia.org/wiki/Special:FilePath/#{ERB::Util.url_encode(file)}?width=#{width}"
  end

  def photo_page_url(file)
    "https://commons.wikimedia.org/wiki/File:#{ERB::Util.url_encode(file)}"
  end

  def photo_credit(file)
    c = PHOTO_CREDITS[file]
    c ? "#{c[:by]} · #{c[:license]}" : "Wikimedia Commons"
  end

  # 11 พ.ย. 14:00
  def thai_datetime(time)
    "#{time.day} #{THAI_MONTHS[time.month - 1]} #{time.strftime('%H:%M')}"
  end

  # "ปิดในอีก 5 ชม." / "เริ่มในอีก 1 วัน" / "ปิดแล้ว"
  def time_left_label(auction, now: Time.current)
    case auction[:status]
    when "live"     then "ปิดในอีก #{thai_duration(auction[:stop_at] - now)}"
    when "upcoming" then "เริ่มในอีก #{thai_duration(auction[:start_at] - now)}"
    else "ปิดประมูลแล้ว"
    end
  end

  # Live auctions closing within 6 hours get an urgent style.
  def closing_soon?(auction, now: Time.current)
    auction[:status] == "live" && auction[:stop_at] - now <= 6.hours
  end

  def auction_type_label(type)
    AuctionsController::TYPES.fetch(type, type)
  end

  private

  def thai_duration(seconds)
    minutes = (seconds / 60).ceil
    if minutes < 60 then "#{[ minutes, 1 ].max} นาที"
    elsif minutes < 24 * 60 then "#{(minutes / 60.0).ceil} ชม."
    else "#{(minutes / (24 * 60.0)).ceil} วัน"
    end
  end
end
