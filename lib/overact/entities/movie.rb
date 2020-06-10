# frozen_string_literal: true

class Movie < Hanami::Entity
  CHECKING = 'checking'
  CHECKED  = 'checked'

  def checked?
    status == CHECKED
  end
end
