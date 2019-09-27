module Api
  module V1
    class TargetsController < ApiController
      def index
        @targets = current_user.targets
      end

      def show
        target
      end

      def destroy
        target.destroy!
      end

      private

      def target
        @target ||= current_user.targets.find(params[:id])
      end
    end
  end
end
