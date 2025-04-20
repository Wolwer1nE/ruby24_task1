include Gem::Text

def close_enough?(str1, str2, max_distance: 4, threshold: 8)
  (str1.length - str2.length).abs <= max_distance &&
    Gem::Text.levenshtein_distance(str1, str2) <= threshold
end

def process_log(file_path)
  names_count = Hash.new(0)

  File.foreach(file_path) do |line|
    next unless line.include?('>')
    name = line.split('>').last.strip
    names_count[name] += 1
  end

  names_count
end

def filter_and_adjust_names(names_count, top_limit: 200)
  sorted_names = names_count.sort_by { |_, count| -count }
  common_names = sorted_names.take(top_limit).to_h
  uncommon_names = sorted_names.drop(top_limit).map(&:first)

  uncommon_names.each do |uncommon|
    common_names.keys.each do |common|
      if close_enough?(uncommon, common)
        common_names[common] += 1
        break
      end
    end
  end

  common_names
end

def print_names(names_count)
  names_count.each do |name, count|
    puts "#{count} #{name}"
  end
end

start_time = Time.now
log_file_path = "C:\\Users\\admin\\Desktop\\ruby24_task1\\data\\log.txt"
names_count = process_log(log_file_path)
filtered_names_count = filter_and_adjust_names(names_count)

print_names(filtered_names_count)

end_time = Time.now
puts "Время работы программы: #{(end_time - start_time).round(2)} сек"
#57 секунд
