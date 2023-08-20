class BroadcasterJob < ApplicationJob
  queue_as :default

  def perform(text)
    Turbo::StreamsChannel.broadcast_update_to("broadcaster",
      target: "broadbox",
      partial: "common/asyncbox",
      locals: {message: text})
  end
end
