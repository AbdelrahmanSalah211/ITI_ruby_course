class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :read, Article
    can [:create], Article
    can [:update, :destroy], Article, user_id: user.id
    can :report, Article

  end
end
