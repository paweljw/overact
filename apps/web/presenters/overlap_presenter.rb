module Web
  class OverlapPresenter
    include Hanami::Presenter

    def actor
      ActorPresenter.new(self[0])
    end

    def role1
      Role.new(self[1])
    end

    def role2
      Role.new(self[2])
    end
  end
end
