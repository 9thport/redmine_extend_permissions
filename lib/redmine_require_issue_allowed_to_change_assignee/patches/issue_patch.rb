module RedmineRequireIssueAllowedToChangeAssignee
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          unloadable

          validate :check_allowed_to_change_assignee?

          protected
          def check_allowed_to_change_assignee?
            # check if the assigned_to_id field changed
            if self.assigned_to_id_changed?
              # check if the user is allowed to change the assigned_to_id field
              if ! User.current.allowed_to?(:allowed_to_change_assignee, @project, :global => true)
                # add error message to explain role is not allowed to change the assignee
                # 
                # TODO: set the assigned_to_id filed to the previous value incase they have forgotten
                errors.add :assigned_to_id, :not_allowed_to_be_changed
              end
            end
          end
        end
      end
    end
  end
end
