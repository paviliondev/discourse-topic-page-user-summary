# frozen_string_literal: true

# name: discourse-topic-page-user-summary
# about: Adds some user attributes to the topic page 
# version: 0.1
# authors: Faizaan Gagan
# url: https://github.com/paviliondev/discourse-topic-page-user-attrs

enabled_site_setting :topic_page_user_summary_enabled

after_initialize do
  add_to_class(:topic_view, :user_summary) do
    if topic_user.present?
      user_summary = UserSummary.new(topic_user.user, guardian)
      user_summary
    else
      false
    end
  end

  add_to_serializer(:topic_view, :created_by) do
    if has_topic_user? && object.user_summary.present?
      UserSummarySerializer.new(object.user_summary, scope: object.guardian, root: false)
    else
      {}  
    end
  end

  add_to_serializer(:user_summary, :created_at) do
    object.user.created_at
  end
end
