FILENAMESPACE = File.basename(__FILE__, '.*')
PATH_ROOT     = File.dirname(__FILE__).freeze
PATH          = File.join(PATH_ROOT, FILENAMESPACE).freeze

puts __FILE__
puts FILENAMESPACE
puts PATH_ROOT
puts PATH
