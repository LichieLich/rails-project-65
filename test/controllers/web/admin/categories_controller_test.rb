# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
    @user = users(:one)
    @admin = users(:admin)
    @attr = { name: Faker::Beer.style }
    sign_in(@user)
  end

  test 'should get index only for admin' do
    assert_raises(Pundit::NotAuthorizedError) { get admin_categories_url }

    sign_in(@admin)

    get admin_categories_url
    assert_response :success
  end

  test 'should get new only for admin' do
    assert_raises(Pundit::NotAuthorizedError) { get new_admin_category_url }

    sign_in(@admin)

    get new_admin_category_url
    assert_response :success
  end

  test 'should get edit only for admin' do
    assert_raises(Pundit::NotAuthorizedError) { get edit_admin_category_url(@category.id) }

    sign_in(@admin)

    get edit_admin_category_url(@category.id)
    assert_response :success
  end

  test 'only admin can update category' do
    assert_raises(Pundit::NotAuthorizedError) { patch admin_category_url(@category), params: { category: @attr } }

    sign_in(@admin)
    patch admin_category_url(@category), params: { category: @attr }

    assert_redirected_to admin_categories_url

    new_category = Category.find_by(@attr)

    assert @category.id == new_category.id
  end

  test 'only admin can create category' do
    assert_raises(Pundit::NotAuthorizedError) { post admin_categories_url, params: { category: @attr } }

    sign_in(@admin)
    post admin_categories_url, params: { category: @attr }

    assert_redirected_to admin_categories_url

    assert Category.find_by(@attr).present?
  end

  test 'only admin can destroy category' do
    assert_raises(Pundit::NotAuthorizedError) { delete admin_category_url(@category) }

    sign_in(@admin)
    delete admin_category_url(@category)

    assert_redirected_to admin_categories_url

    assert Category.find_by(id: @category.id).nil?
  end
end
