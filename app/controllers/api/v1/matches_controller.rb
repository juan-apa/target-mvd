module Api
  module V1
    class MatchesController < ApiController
      def index
        @matches = Match.user_matches(current_user)
      end

      def show
        match
      end

      private

      def match
        @match ||= Match.user_matches(current_user).find(params[:id])
      end
    end
  end
end
