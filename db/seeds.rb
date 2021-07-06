# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

prefs = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
    '海外'
]

prefs.each do |pref|
   Pref.create(:name=>pref) 
end

Course.create(:name=>'ライトコース',:tickets=>5,:price=>3850,:valid_date=>'１ヶ月',:status=>true,:comment=>'どうしてもわからない時に！',:price_id=>'price_1J1K9iHz8Iexb7QlqqMXtJaA')
Course.create(:name=>'ベーシックコース',:tickets=>12,:price=>7700,:valid_date=>'１ヶ月',:status=>true,:comment=>'塾が休みの日に！',:price_id=>'price_1J1K9iHz8Iexb7QlyGJoeylG')
Course.create(:name=>'マスターコース',:tickets=>20,:price=>10780,:valid_date=>'１ヶ月',:status=>true,:comment=>'行き詰まった時はいつでも！',:price_id=>'price_1J1K9iHz8Iexb7Ql0OEzZ0pv')
Course.create(:name=>'追加チケット',:tickets=>5,:price=>3850,:valid_date=>'１年',:status=>true,:subscription=>false,:comment=>'1年有効チケットで足りない時に便利',:price_id=>'price_1J4LGMHz8Iexb7QlBUUZRSgU')

