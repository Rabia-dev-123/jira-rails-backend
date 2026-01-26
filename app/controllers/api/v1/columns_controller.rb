class Api::V1::ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: [:show, :update, :destroy]

  # GET /boards/:board_id/columns
  # Returns all columns of a board, ordered by position
  def index
    columns = @board.columns.order(:position)
    render json: columns, status: :ok
  end

  # POST /boards/:board_id/columns
  # Create a new column in a board
  def create
    column = @board.columns.build(column_params)

    if column.save
      render json: column, status: :created
    else
      render json: { errors: column.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /boards/:board_id/columns/:id
  # Show a single column
  def show
    render json: @column, status: :ok
  end

  # PATCH /boards/:board_id/columns/:id
  # Update column title or position
  def update
    if @column.update(column_params)
      render json: @column, status: :ok
    else
      render json: { errors: @column.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /boards/:board_id/columns/:id
  # Delete a column
  def destroy
    @column.destroy
    render json: { message: "Column deleted successfully" }, status: :ok
  end

  private

  # Find board based on current user
  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  # Find specific column
  def set_column
    @column = @board.columns.find(params[:id])
  end

  # Strong params
  def column_params
    params.require(:column).permit(:title, :position)
  end

  # TEMP current_user for testing
  # Replace with real authentication later
  def current_user
    User.first
  end
end
