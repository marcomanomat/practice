# process_aws_events.rb

require 'open-uri'
require 'fileutils'
require 'zlib'
require 'json'

# Download the tar file
tar_url = 'https://example.com/downloads/example_logs.tar'
tar_file = 'example_logs.tar'

File.open(tar_file, 'wb') do |file|
  file.write(URI.open(tar_url).read)
end

# Untar the file
untar_dir = 'example_logs'
FileUtils.mkdir_p(untar_dir)
system("tar -xf #{tar_file} -C #{untar_dir}")

# Unzip the .json.gz files
json_dir = 'json_files'
FileUtils.mkdir_p(json_dir)

Dir.glob("#{untar_dir}/**/*.json.gz").each do |gz_file|
  Zlib::GzipReader.open(gz_file) do |gz|
    json_file = File.join(json_dir, File.basename(gz_file, '.gz'))
    File.write(json_file, gz.read)
  end
end

# Collect unique AWS events per region
events_per_region = Hash.new { |hash, key| hash[key] = Hash.new(0) }

Dir.glob("#{json_dir}/*.json").each do |json_file|
  data = JSON.parse(File.read(json_file))
  
  # Assumption: Each JSON object has 'awsRegion' and 'eventName' fields
  data.each do |event|
    region = event['awsRegion']  # Assumption: 'awsRegion' is a key in the JSON object
    event_name = event['eventName']  # Assumption: 'eventName' is a key in the JSON object
    events_per_region[region][event_name] += 1
  end
end

# Print the report in the specified format
events_per_region.each do |region, events|
  puts region
  events.sort_by { |event_name, count| [-count, event_name] }.each do |event_name, count|
    puts "#{event_name}: #{count}"
  end
  puts '. . .'
end

# Extra credit: Highlight potential issues, aligning with the tasks support engineers might handle
threshold = 1000  # Define the threshold for flagging potentially problematic events; 1000 chosen arbitrarily

puts "Potential Issues Detected (Events Exceeding Threshold of #{threshold} Occurrences):"
events_per_region.each do |region, events|
  flagged_events = events.select { |event_name, count| count > threshold }
  unless flagged_events.empty?
    puts "Region: #{region}"
    flagged_events.sort_by { |event_name, count| [-count, event_name] }.each do |event_name, count|
      puts "  #{event_name}: #{count} occurrences"
    end
    puts '. . .'
  end
end
