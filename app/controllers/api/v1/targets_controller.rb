module Api
  module V1
    class TargetsController < ApiController
      def index
        @targets = current_user.targets
      end

      def create
        @target = current_user.targets.create! targets_params
      end

      def show
        target
      end

      private

      def target
        @target ||= current_user.targets.find(params[:id])
      end

      def targets_params
        params.require(:target).permit(:title, :latitude, :longitude, :topic_id, :radius)
              .merge(user_id: current_user.id)
      end
    end
  end
end
