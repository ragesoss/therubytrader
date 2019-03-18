module KeyboardInput
  def set_button_down &procedure
    $window.on_button_down = procedure
    def $window.button_down id
      on_button_down.call id
    end
  end

  def unset_button_down
    def $window.button_down id
      super
    end
  end
end
