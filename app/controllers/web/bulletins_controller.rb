# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action only: %i[new create destroy update edit admin_index] do
      authorize Bulletin
    end

    def index
      @bulletins = Bulletin.all.order(created_at: :desc)
    end

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

    def admin_index
      @bulletins = Bulletin.all.order(created_at: :desc)
      render 'web/admin/bulletins/index'
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
end
