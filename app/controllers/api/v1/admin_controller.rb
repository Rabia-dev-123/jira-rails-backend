class Api::V1::AdminController < ApplicationController
     before_action :require_admin

      # GET /api/v1/admin
      def index
        users = User.all
        boards = Board.all
        render json: { users: users, boards: boards }
      end

      private

      def require_admin
        unless current_user&.admin?
          render json: { error: "Access denied" }, status: :forbidden
        end
      end
end
