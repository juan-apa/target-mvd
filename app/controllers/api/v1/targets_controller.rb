module Api
  module V1
    class TargetsController < ApiController
      def index
        @targets = current_user.targets
      end

      def create
        @target = current_user.targets.create!(target_params)
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

      def target_params
        params.require(:target).permit(:title, :latitude, :longitude, :topic_id, :radius)
      end
    end
  end
end
