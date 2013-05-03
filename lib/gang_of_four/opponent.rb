module GangOfFour
  class Opponent
    attr_reader :name, :host, :port

    def initialize(name, host, port)
      @name = name
      @host = host
      @port = port
    end
  end
end
