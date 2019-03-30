require_relative '../quest'

class BadPenny < Quest
  def show? interface
    interface.class == AtMarket
  end

  STAGES = [:start, :talk, :complete]
  def initialize *args
    @stage = :start
    super
  end

  def requirements_met?
    $adventurer.inventory.goods[:rubies] >= 2
  end

  def possible_actions
    [:learn_more, :decline, :complete]
  end

  def options
    if @stage == :start
      return {} unless rand > 0.8
      return { learn_more: 'Talk with a man who whispers that he has a "bad penny".' }
    elsif @stage == :talk
      return {
        complete: "Give him two rubies",
        decline: "Decline the offer and move on"
      }
    end
    {}
  end

  def decline _interface
    @stage = :start
    return Action.failure "You move on, and when you turn back, the man is gone."
  end

  def learn_more _interface
    if requirements_met?
      @stage = :talk
      return Action.success 'You follow the man to an alley, and he makes you an offer: two rubies for the (allegedly) rare and wondrous "Bad Penny".'
    else
      @stage = :start
      return Action.failure "You follow the man to an alley, and he makes you an offer: two rubies for the (allegedly) rare and wondrous \"Bad Penny\". Unfortunately, you don't have the rubies, so you move on."
    end
  end

  def complete interface
    $state[:towns][place].quests -= [self]
    $adventurer.inventory.goods[:rubies] -= 2
    $adventurer.inventory.special_items[:bad_penny] = true
    return Action.success "You hand over the rubies for the coin. It looks like nothing more than a scratched and dirty #{MONEY}."
  end
end