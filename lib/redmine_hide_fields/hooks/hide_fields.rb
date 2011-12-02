module RedmineHideFields
  module Hooks
    class HideFields < Redmine::Hook::ViewListener
      def initialize
        @no_of_fields=0
      end

      # the method below adds javascript code to the bottom of the "view_issues_form_details" page
      # 
      # each if statement links to a permission defined in the init.rb file
      # the list variable contains the ID of the field that will be hidden
      # 
      # for each if statement that returns false, the @no_of_fields is incremented by 1
      #
      #
      # TODO: clean up the following method with a better solution to hide fields
      # TODO: add code for when viewing an issue to hide fields
      def view_issues_form_details_bottom(context={})
        list = Array.new
        
        # view_assigned_to
        if User.current.allowed_to?(:view_issue_assigned_to, @project, :global => true)
        else
          list << "issue_assigned_to_id"
          @no_of_fields += 1
        end
        
        # view_issue_parent_issue_id
        if User.current.allowed_to?(:view_issue_parent_issue_id, @project, :global => true)
        else
          list << "issue_parent_issue_id"
          @no_of_fields += 1
        end
        
        # view_issue_done_ratio
        if User.current.allowed_to?(:view_issue_done_ratio, @project, :global => true)
        else
          list << "issue_done_ratio"
          @no_of_fields += 1
        end
        
        if @no_of_fields == 1
          hide_field_with_id_from_list(list[0], @no_of_fields)
        else
          hide_field_with_id_from_list(list, @no_of_fields)
        end
        
        ##################################
        # testing variables to text file #
        ##################################
        
        # myStr = "Written on #{Time.now.to_s}\n"
        # myStr << "fields:\n #{@no_of_fields}"
        # if ! list.empty?
        #   if @no_of_fields = 1
        #     myStr << list[0]
        #   else
        #     myStr << list
        #   end
        # end
        
        # myStr << "\n"
        # myStr << "total_fields:"
        # myStr << "\n"
        # myStr << @no_of_fields.to_s
        # myStr << "\n"
        # myStr << User.current.allowed_to?(:view_issue_assigned_to, @project, :global => true).to_s
        # myStr << "\n"
        # myStr << User.current.allowed_to?(:view_issue_parent_issue_id, @project, :global => true).to_s
        # myStr << "\n"
        # myStr << User.current.allowed_to?(:view_issue_done_ratio, @project, :global => true).to_s
        # myStr << "\n"
        # # myStr << hide_field_with_id_from_list(list[0], no_of_fields)
        # if no_of_fields = 1
        #   myStr << hide_field_with_id_from_list(list[0], @no_of_fields)
        # else
        #   myStr << hide_field_with_id_from_list(list, @no_of_fields)
        # end
        
        # aFile = File.new("/Users/aaron/myString.txt", "w")
        # aFile.write(myStr)
        # aFile.close
        
        #########################################
        # end of testing variables to text file #
        #########################################
        
        
      end

      # method that returns the javascript for hiding fields
      # if the @no_of_fields is greater than 1, there needs to be a different sent of javascript code needed to use the 'each' method
      def hide_field_with_id_from_list(fields, total_fields)
        
        a = ''
        a << '<script type="text/javascript" language="javascript">'

        # Create the class
        a << 'var hideField = Class.create({'
        a << 'initialize:function()'
        
        # Find the element with the id "issue_assigned_to_id" and move up to the parent, then set the display to hide
        if total_fields == "1"
          a << '{'
          a << '$("'
          a << fields
          a << '").up().hide();'
          a << '}'
          a << '});'          
        else
          a << '{'
          a << '$('
          a << fields.to_s
          a << ').each(function(s) { $(s).up().hide(); })'
          a << '}'
          a << '});'
        end
                
        # Global variable for the instance of the class
        a << 'var execHideField;'
        
        # Creating an instance of the class if the page has finished loading
        a << 'Event.observe(window, "load", function() {'
        a << 'execHideField = new hideField();'
        a << '});'
        
        a << '</script>'
                
        # return the javascript code appended from above
        return a
      end    
    end
  end
end
