# frozen_string_literal: true

module Web
  module Views
    module Compare
      class Show
        include Web::View

        def overlap
          overlapping_roles.map { |row| OverlapPresenter.new(row) }
        end

        def movies_ready?
          movie1&.checked? && movie2&.checked?
        end

        def page_title
          _raw(movies_ready? ? "#{movie1.name} vs #{movie2.name}" : '[Working...]')
        end
      end
    end
  end
end
