require 'open-uri'
require 'csv'

#user_agentを設定
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset = nil

CSV.foreach('company.csv',headers:true) do |data|
  #company.csvからカラム"company"の情報を取得
  name = data["company"]
  #google検索をかける
  url = "https://www.google.co.jp/search?q=#{name}"
  #url用にエンコード
  url_escape = URI.escape(url)

  html = open(url_escape, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end
  # <h3 class="r">-ここにはさまれた文字列-</h3>を集める
  strs =  html.scan(%r{<h3 class="r">(.+?)</h3>})
  # <a>タグの中のhref属性とタイトルを抜き出す
    url, title = (strs[0][0].scan(%r{<a href="(.+?)".+?>(.+?)</a>}))[0]
    puts "#{title} #{url}"
    # ファイルへ書き込み
    CSV.open("companyurl.csv", "a") do |csv|
      csv << ["#{title}","#{url}"]
    end
end
