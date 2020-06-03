class Movie < Hanami::Entity
  CHECKING = 'checking'.freeze
  CHECKED  = 'checked'.freeze

  def checked?
    status == CHECKED
  end
end
