# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  attr_reader :user, :bulletin

  def initialize(user, bulletin)
    super
    @user = user
    @bulletin = bulletin
  end

  def index?
    true
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def edit?
    bulletin.user_id == user.id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def admin_index?
    user.admin?
  end

  def profile?
    user.present?
  end

  def archive?
    bulletin.user_id == user.id || user.admin?
  end

  def publish?
    user.admin?
  end

  def reject?
    publish?
  end

  def send_to_moderation?
    create?
  end
end
