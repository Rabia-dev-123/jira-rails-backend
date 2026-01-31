class Api::V1::TasksController < ApplicationController
   before_action :set_board
      before_action :set_column
      before_action :set_task, only: [ :show, :update, :destroy ]

      # GET /boards/:board_id/columns/:column_id/tasks
    def index
       tasks = @column.tasks.includes(:user).order(:position)
       render json: tasks.as_json(include: { user: { only: [:id, :name] } })
        end
 

      # POST /boards/:board_id/columns/:column_id/tasks
   def create
  task = @column.tasks.build(task_params)

  if task.save
    render json: task, status: :created
  else
    render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
  end
   end


      # GET /boards/:board_id/columns/:column_id/tasks/:id
      def show
        render json: @task
      end

      # PATCH /boards/:board_id/columns/:column_id/tasks/:id
def update
  task = @column.tasks.find(params[:id])
  
  # Try to update, but don't fail on validation
  if task.update(task_params)
    render json: task
  else
    # Log the errors for debugging
    Rails.logger.error "Task update failed: #{task.errors.full_messages}"
    render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
  end
end
   # DELETE /boards/:board_id/columns/:column_id/tasks/:id
      def destroy
        @task.destroy
        render json: { message: "Task deleted successfully" }
      end
def move
  Rails.logger.info "MOVE ACTION CALLED: task_id=#{params[:id]}, column_id=#{params[:column_id]}"
  
  begin
    task = Task.find(params[:id])
    Rails.logger.info "Task found: #{task.inspect}"
    
    new_column = Column.find(params[:column_id])
    Rails.logger.info "New column found: #{new_column.inspect}"
    
    # Only update column_id - board association is automatic through column
    if task.update(column_id: new_column.id)
      Rails.logger.info "Task updated successfully"
      
      # Return the task WITH user data included
      render json: task.as_json(include: { user: { only: [:id, :name] } })
    else
      Rails.logger.error "Task update failed: #{task.errors.full_messages}"
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "ERROR in move action: #{e.message}\n#{e.backtrace.join("\n")}"
    render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
  end
end
      private

      def set_board
        @board = current_user.boards.find(params[:board_id])
      end

      def set_column
        @column = @board.columns.find(params[:column_id])
      end

      def set_task
        @task = @column.tasks.find(params[:id])
      end
def task_params
  params.require(:task).permit(:title, :description, :user_id, :column_id)
end
  def current_user
    User.first end
end
