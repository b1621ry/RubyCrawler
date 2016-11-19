#完走タイムの計算
require "time"
require "date"
sexJudgeElite = /WElite/
sexJudgeNomal = /W[0-9][0-9]-[0-9][0-9]/
time = /([0-9][0-9]):([0-9][0-9]):([0-9][0-9])/
#▽全員のタイムの総和
sum_hours = 0
sum_min = 0
sum_second = 0
#▽完走人数
finish_num = 0

#▽分散計算用変数
sum_xi = 0
variance = 0

#▽中間値検出用配列
data = Array.new

#▽ヒストグラム用データ書き出し
basetime = 7200
count_freq = 0
file = "women.txt"
mode = "a"

#▽CDF用
count_cum = 0


#00:00:00の合計を〜分に変換するメソッド 小数点切り捨て
def sec_trans(hours,min,second)
  ret_sec = (hours * 3600) + (min * 60) + second  
  return ret_sec
end
public :sec_trans




ARGF.each_line do |line|
  if sexJudgeElite.match(line) || sexJudgeNomal.match(line)
    time.match(line)
    hours = $1.to_i
    minute = $2.to_i
    second = $3.to_i
    
    sum_hours += hours
    sum_min += minute
    sum_second += second
    finish_num += 1;
    
    xi = sec_trans(hours,minute,second)
    sum_xi += (xi * xi)
    
    data.push xi
    #▽ヒストグラム用
    i = true
    while i 
      if basetime - xi <= 600 && basetime - xi >= 0
        count_freq = count_freq + 1
        count_cum += 1
        i = false 
      
      else
        if basetime - xi > 600 
          basetime -= 600         
        else
          basetime += 600
        end 
       bs_time = (basetime / 60).truncate
       str = "#{bs_time}  #{count_freq} #{count_cum}\n"
        #ファイルに書き出し
        open(file , mode ){|f| f.write(str)}
        count_freq = 0
      end
    end
              
  end
end

data.sort!


#▽平均の計算
average_time = Float(sec_trans(sum_hours,sum_min,sum_second) / finish_num)
puts("average time is #{average_time}")


#▽標準偏差の計算
variance = Float(sum_xi / finish_num) - (average_time * average_time)
puts("variance is #{variance}")
stddev = Math.sqrt(variance).truncate
puts("stddev is #{stddev}")

#▽中間値の計算
n = data.length # number of array elements
r = n / 2 # when n is odd, n/2 is rounded down
if n % 2 != 0
median = data[r]
else
median = (data[r - 1] + data[r])/2
end
printf "r:%d median:%d\n", r, median