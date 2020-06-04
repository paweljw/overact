module Web
  module Views
    module Compare
      class Show
        include Web::View

        def overlap
          overlapping_roles.map { |row| OverlapPresenter.new(row) }
        end

        def movies_ready?
          movie1.checked? && movie2.checked?
        end
      end
    end
  end
end
