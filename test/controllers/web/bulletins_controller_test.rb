# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    @bulletin.image.attach(io: File.open('test/fixtures/files/test_file.jpeg'), filename: 'test_file.jpeg')
    @user = users(:one)
    @attr = {
      title: Faker::BossaNova.artist,
      category_id: categories(:one).id,
      description: Faker::ChuckNorris.fact
    }
    sign_in(@user)
  end

  test 'should get index' do
    get bulletins_url
    assert_response :success
  end

  test 'should show bulletin' do
    get bulletin_url(@bulletin)
    assert_response :success
  end

  test 'should get new bulletin' do
    get new_bulletin_url
    assert_response :success
  end

  test 'should get edit url' do
    get edit_bulletin_url(@bulletin)
    assert_response :success
  end

  test 'can edit bulletin' do
    patch bulletin_url(@bulletin), params: { bulletin: @attr }
    assert_redirected_to bulletin_url(@bulletin)

    new_bulletin = Bulletin.find_by(@attr)

    assert @bulletin.id == new_bulletin.id
  end

  test 'should create bulletin' do
    @attr[:image] = fixture_file_upload('test/fixtures/files/test_file.jpeg', 'image/jpeg')
    post bulletins_url, params: { bulletin: @attr }

    new_bulletin = Bulletin.find_by(title: @attr[:title], description: @attr[:description], category_id: @attr[:category_id])

    assert new_bulletin.present?
    assert_redirected_to bulletin_url(new_bulletin)
  end

  test 'should destroy bulletin' do
    delete bulletin_url(@bulletin)
    assert_redirected_to root_url

    assert Bulletin.find_by(id: @bulletin.id).nil?
  end

  test 'should get profile' do
    get profile_url
    assert_response :success
  end

  test 'should be archived' do
    patch archive_bulletin_url(@bulletin)
    assert_redirected_to root_url

    assert Bulletin.find(@bulletin.id).aasm_state == 'archived'
  end

  test 'should be sent to moderation' do
    patch moderation_bulletin_url(@bulletin)
    assert_redirected_to root_url

    assert Bulletin.find(@bulletin.id).aasm_state == 'under_moderation'
  end
end
