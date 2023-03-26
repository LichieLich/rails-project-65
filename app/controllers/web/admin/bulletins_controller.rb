# frozen_string_literal: true

module Web::Admin
  class BulletinsController < ApplicationController
    before_action only: %i[admin_index bulletins_under_moderation] do
      authorize Bulletin
    end

    def admin_index
      @q = Bulletin.all.includes(:category).ransack(params[:q])
      @bulletins = @q.result.order(created_at: :desc).page(params[:page]).per(10)
    end

    def bulletins_under_moderation
      @bulletins = Bulletin.where(state: 'under_moderation').order(created_at: :desc).page(params[:page]).per(20)
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

    def archive
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
      @bulletin.archive!

      redirect_back(fallback_location: :root, notice: t('.success'))
    end

    private

    # Only allow a list of trusted parameters through.
    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
