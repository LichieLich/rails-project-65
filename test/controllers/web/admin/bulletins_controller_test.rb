# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    @bulletin.image.attach(io: File.open('test/fixtures/files/test_file.jpeg'), filename: 'test_file.jpeg')
    @user = users(:one)
    @admin = users(:admin)
    sign_in(@admin)
  end

  test 'admin index should be visible only for admin' do
    sign_in(@user)
    assert_raises(Pundit::NotAuthorizedError) { get admin_bulletins_url }

    sign_in(@admin)

    get admin_bulletins_url
    assert_response :success
  end

  test 'should get bulletins under moderation only for admin' do
    sign_in(@user)
    assert_raises(Pundit::NotAuthorizedError) { get admin_url }

    sign_in(@admin)

    get admin_url
    assert_response :success
  end

  test 'should be published' do
    @bulletin.state = 'under_moderation'
    @bulletin.save

    patch publish_admin_bulletin_url(@bulletin)
    assert_redirected_to root_url

    assert Bulletin.find(@bulletin.id).state == 'published'
  end

  test 'should be rejected' do
    @bulletin.state = 'under_moderation'
    @bulletin.save

    patch reject_admin_bulletin_url(@bulletin)
    assert_redirected_to root_url

    assert Bulletin.find(@bulletin.id).state == 'rejected'
  end
end
