module Api
  module V1
    class TargetsController < ApiController
      def create
        @target = Target.create!(targets_params)
      end

      def index
        @targets = Target.all
      end

      def update
        @target = Target.update(params[:id], targets_params)
      end

      def show
        target
      end

      def destroy
        Target.destroy(params[:id])
      end

      private

      def target
        @target ||= Target.find(params[:id])
      end

      def targets_params
        params.require(:target).permit(:title, :radius, :latitude, :longitude, :topic_id)
              .merge(user_id: current_user.id)
      end
    end
  end
end
