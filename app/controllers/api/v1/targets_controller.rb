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
        current_user.targets.destroy(params[:id])
      end

      private

      def target
        @target ||= current_user.targets.find(params[:id])
      end
    end
  end
end
