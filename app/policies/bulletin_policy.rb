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
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def profile?
    user.present?
  end

  def archive?
    owner? || user.admin?
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

  def bulletins_under_moderation?
    user.admin?
  end

  private

  def owner?
    bulletin.user_id == user.id
  end
end
