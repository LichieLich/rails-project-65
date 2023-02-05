# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  attr_reader :user, :bulletin

  def initialize(user, bulletin)
    super
    @user = user
    @bulletin = bulletin
  end

  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    bulletin.user == user
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
end
