module Api
  module V1
    class TopicsController < ApiController
      def index
        @topics = Topic.all
      end

      def show
        id = params[:id]
        @topic = Topic.find(id)
      end
    end
  end
end
