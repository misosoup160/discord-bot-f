# frozen_string_literal: true

module ApplicationHelper
  def admin_page_or_not
    controller_path.split('/').include?('admin') ? 'is-admin-page' : ''
  end
end
