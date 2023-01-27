# frozen_string_literal: true

class Web::BulletinsController < ApplicationController
  before_action :authenticate!, only: %i[new create destroy update edit]

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
  end

  def edit
    @bulletin = helpers.current_user.bulletins.find(params[:id])
  end

  def create
    @bulletin = helpers.current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to bulletin_path(@bulletin), notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bulletin = helpers.current_user.bulletins.find(params[:id])

    if @bulletin.update(bulletin_params)
      redirect_to bulletin_path(@bulletin), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bulletin = helpers.current_user.bulletins.find(params[:id])

    @bulletin.destroy
    redirect_to root_path, notice: t('.success')
  end

  private

  # Only allow a list of trusted parameters through.
  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end

  def authenticate!
    raise ActionController::RoutingError, 'Not Found' unless helpers.current_user
  end
end
