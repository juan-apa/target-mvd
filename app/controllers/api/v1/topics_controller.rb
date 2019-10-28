module Api
  module V1
    class TopicsController < ApiController
      helper_method :topic

      def index
        @topics = Topic.all
      end

      def show
        topic
      end

      private

      def topic
        @topic ||= Topic.find(params[:id])
      end
    end
  end
end
