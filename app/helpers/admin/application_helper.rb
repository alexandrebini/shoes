module Admin::ApplicationHelper
  def nav_item(item)
    content_tag :li do
      link_to t('.title', default: item.to_s.classify.constantize.model_name.human.pluralize.titleize), [:admin, item]
    end
  end
end