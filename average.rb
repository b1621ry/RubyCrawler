# regular expression to read minutes and count
     re = /^(\d+)\s+(\d+)/ #数字　スペース　
     sum = 0 # sum of data
     n = 0 # the number of data
     ARGF.each_line do |line|
         if re.match(line)
             min = $1.to_i
             cnt = $2.to_i
             sum += min * cnt
n += cnt end
     end
     mean = Float(sum) / n
     printf "n:%d mean:%.1f\n", n, mean