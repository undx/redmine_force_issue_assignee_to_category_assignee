require 'redmine'

Redmine::Plugin.register :redmine_force_issue_assignee_to_category_assignee do
  name 'Redmine Force issue\'s assignee to category\'s assignee Plugin'
  author 'Emmanuel GALLOIS (undx)'
  description 'This plugin overrides issue\'s assignee to category\'s assignee if declared. If category has no assignee and issue is assigned, assignee remains.'
  version '0.0.1'
  url 'http://github.com/undx/redmine_force_issue_assignee_to_category_assignee'
  author_url 'http://github.com/undx'
end

module IssueAssignToPlugin
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_edit_before_save(context={})
      if context[:params] && context[:issue] && (context[:issue][:category_id]||context[:issue].category)
        cat = IssueCategory.find context[:issue][:category_id]||context[:issue].category.id
        if cat.assigned_to
          context[:issue].assigned_to_id = cat.assigned_to.id
        end
      end
      return ''
    end
    alias_method :controller_issues_bulk_edit_before_save, :controller_issues_edit_before_save
    alias_method :controller_issues_new_before_save,       :controller_issues_edit_before_save
  end
end

