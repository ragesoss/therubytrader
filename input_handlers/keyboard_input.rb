module KeyboardInput
  def set_button_down &procedure
    $window.on_button_down = procedure
    def $window.button_down id
      on_button_down.call id
    end
  end
end
