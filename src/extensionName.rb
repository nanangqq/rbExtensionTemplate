require 'sketchup.rb'
require 'extensions.rb'
require 'json'

module CreatorName
  module ExtensionName
    FILENAMESPACE = File.basename(__FILE__, '.*')
    PATH_ROOT     = File.dirname(__FILE__).freeze
    PATH          = File.join(PATH_ROOT, FILENAMESPACE).freeze

    extension_json_file = File.join(PATH, 'extension.json')
    extension_json = File.read(extension_json_file)
    EXTENSION = ::JSON.parse(extension_json, symbolize_names: true).freeze

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new(EXTENSION[:name], 'extensionName/main')
      ex.description = EXTENSION[:description]
      ex.version     = EXTENSION[:version]
      ex.copyright   = EXTENSION[:copyright]
      ex.creator     = EXTENSION[:creator]

      Sketchup.register_extension(ex, true)

      file_loaded(__FILE__)
    end

  end
end
