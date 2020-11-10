module CreatorName
  module ExtensionName
    class Test
      @@model = Sketchup.active_model

      def initialize(name)
        @name = name
      end

      def m(content)
        UI.messagebox(content)
      end

      def put_save_message
        m('%s model saved. (%s entities, version 2018)'%[@name, get_entities_cnt])
      end

      attr_accessor :name

      private

      def get_entities_cnt
        return @@model.active_entities.length
      end
    end
  end
end

