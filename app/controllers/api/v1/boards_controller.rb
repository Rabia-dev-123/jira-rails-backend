class Api::V1::BoardsController < ApplicationController
  before_action :set_board, only: [:show, :update, :destroy] # Include :show

  # GET /api/v1/boards
  def index
    boards = current_user.boards.includes(:columns)
    render json: boards, include: [:columns]
  end

  # GET /api/v1/boards/:id
  def show
    render json: @board, include: [:columns, columns: :tasks] # Include tasks too
  end

  # POST /api/v1/boards
  def create
    # Extract column_title from params
    column_title = params[:column_title] || "To Do"
    
    # Build board
    board = current_user.boards.build(board_params)

    if board.save
      # Create column
      board.columns.create(title: column_title)
      
      render json: board, include: [:columns], status: :created
    else
      render json: { errors: board.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/boards/:id
  def update
    if @board.update(board_params)
      render json: @board
    else
      render json: { errors: @board.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/boards/:id
# In boards_controller.rb
def destroy
  board = Board.find(params[:id])
  if board.destroy
    render json: { message: "Board deleted successfully" }, status: :ok
  else
    render json: { error: board.errors.full_messages }, status: :unprocessable_entity
  end
end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title)
  end

  def current_user
    User.first # For testing
  end
end