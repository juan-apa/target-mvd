module Api
  module V1
    class AboutController < ApiController
      skip_before_action :authenticate_user!
      helper_method :about

      def index; end

      private

      def about
        @about ||= About.all.first
      end
    end
  end
end
