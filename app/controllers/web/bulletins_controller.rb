# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action only: %i[new create admin_index profile] do
      authorize Bulletin
    end

    def index
      @q = Bulletin.ransack(params[:q])
      @bulletins = @q.result.where(aasm_state: 'published').order(created_at: :desc)
    end

    def show
      @bulletin = Bulletin.find(params[:id])
    end

    def new
      @bulletin = Bulletin.new
    end

    def edit
      @bulletin = helpers.current_user.bulletins.find(params[:id])
      authorize @bulletin
      @bulletin.draft!
    end

    def create
      @bulletin = helpers.current_user.bulletins.build(bulletin_params)
      authorize @bulletin

      if @bulletin.save
        redirect_to bulletin_path(@bulletin), notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @bulletin = helpers.current_user.bulletins.find(params[:id])
      authorize @bulletin

      if @bulletin.update(bulletin_params)
        redirect_to bulletin_path(@bulletin), notice: t('.success')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @bulletin = helpers.current_user.bulletins.find(params[:id])
      authorize @bulletin

      @bulletin.destroy
      redirect_to root_path, notice: t('.success')
    end

    def admin_index
      @q = Bulletin.all.includes(:category).ransack(params[:q])
      @bulletins = @q.result.order(created_at: :desc).page params[:page]

      render 'web/admin/bulletins/index'
    end

    def profile
      @q = Bulletin.includes(:category).ransack(params[:q])
      @bulletins = @q.result.where(user_id: current_user.id).order(created_at: :desc).page params[:page]
    end

    def archive
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
      @bulletin.archive!

      redirect_back(fallback_location: :root, notice: t('.success'))
    end

    def publish
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
      @bulletin.publish!

      redirect_back(fallback_location: :root, notice: t('.success'))
    end

    def reject
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
      @bulletin.reject!

      redirect_back(fallback_location: :root, notice: t('.success'))
    end

    def send_to_moderation
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
      @bulletin.moderate!

      redirect_back(fallback_location: :root, notice: t('.success'))
    end

    private

    # Only allow a list of trusted parameters through.
    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end

    # def authenticate!
    #   raise ActionController::RoutingError, 'Not Found' unless helpers.current_user
    # end
  end
end
