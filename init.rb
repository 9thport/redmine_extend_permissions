require 'redmine'

Redmine::Plugin.register :redmine_extend_permissions do
  name 'Redmine Extend Permissions plugin'
  author 'Aaron Addleman'
  description 'This is a plugin for Redmine to add additional permissions to views or controllers'
  version '0.0.1'
  url 'http://9thport.net/2011/03/20/redmine-hide-assigned-to-field-with-role-permissions-plugin/'
  author_url 'http://9thport.net'

  permission :view_assigned_to, :issues => :index
  permission :view_estimated_hours, :issues => :index
  permission :view_done_ratio, :issues => :index
  permission :view_attachment_description, :attachments => :index

Redmine::MenuManager.map :top_menu do |menu|
  menu.push :help_me, Redmine::Info.help_url, :last => true
end

end

