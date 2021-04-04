# frozen_string_literal: true

# name: discourse-topic-page-user-summary
# about: Adds some user attributes to the topic page 
# version: 0.1
# authors: Faizaan Gagan
# url: https://github.com/paviliondev/discourse-topic-page-user-attrs

enabled_site_setting :topic_page_user_summary_enabled

after_initialize do
  add_to_class(:topic_view, :user_summary) do
    user_summary = UserSummary.new(topic.user, guardian)
    user_summary
  end

  add_to_serializer(:topic_view, :created_by) do
    if scope.can_see_summary_stats?(object.topic.user)
      UserSummarySerializer.new(object.user_summary, scope: scope, root: false)
    end
  end

  add_to_serializer(:user_summary, :created_at) do
    if scope.can_see_summary_stats?(object.user)
      object.user.created_at
    end
  end
end
