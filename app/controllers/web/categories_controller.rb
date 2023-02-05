# frozen_string_literal: true

module Web
  class CategoriesController < ApplicationController
    before_action do
      authorize Category
    end

    def index
      @categories = Category.all
      render 'web/admin/categories/index'
    end

    def new
      @category = Category.new
      render 'web/admin/categories/new'
    end

    def edit
      @category = Category.find(params[:id])
      render 'web/admin/categories/edit'
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: t('.success')
      else
        render 'web/admin/categories/new', status: :unprocessable_entity
      end
    end

    def update
      @category = Category.find(params[:id])

      if @category.update(category_params)
        redirect_to admin_categories_path, notice: t('.success')
      else
        render 'web/admin/categories/edit', status: :unprocessable_entity
      end
    end

    def destroy
      @category = Category.find(params[:id])

      @category.destroy
      redirect_to admin_categories_path, notice: t('.success')
    end

    private

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
  end
end
