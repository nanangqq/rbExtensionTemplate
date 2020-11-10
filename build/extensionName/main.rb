require 'sketchup.rb'
require 'json'
require_relative './test_class'
require_relative './test_module'

module CreatorName
  module ExtensionName

    class Interface
      @@model = Sketchup.active_model

      def activate
        t = Test.new('stacy')

        current_path = @@model.path
        if current_path.length > 0
          result = @@model.save(current_path, Sketchup::Model::VERSION_2018)

          if result
            t.put_save_message
          end
        else
          t.m('save model first.')
        end

        pt = Geom::Point3d.new(3,5,7)
        t.m(Utils.get_flipped_point(Geom::Point3d.new(1,3,5), pt, 'z'))

        @@model.commit_operation

        Sketchup.active_model.select_tool(nil)

      end

      def deactivate(view)
        view.invalidate
      end

      private

      def say_hello()
        UI.messagebox('hello')
      end

    end

    def self.activate_interface
      Sketchup.active_model.select_tool(Interface.new)
    end

    unless file_loaded?(__FILE__)
      toolbar = UI::Toolbar.new "extensionName"
      cmd = UI::Command.new("extensionName") {
        self.activate_interface
      }

      cmd.small_icon = 'save_2018-01.png'
      cmd.large_icon = 'save_2018-01.png'
      cmd.tooltip = 'save_2018'
      cmd.status_bar_text = 'save_2018'
      cmd.menu_text = 'save_2018'

      toolbar = toolbar.add_item cmd
      toolbar.show

      file_loaded(__FILE__)
    end

  end
end
