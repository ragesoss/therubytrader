require_relative '../input_handlers/keyboard_input'

class Interface
  include KeyboardInput

  def update
  end

  def create
    $window.add_element self
  end

  def destroy
    $window.remove_element self
  end
end
