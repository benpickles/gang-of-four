module GangOfFour
  class Message
    attr_reader :args, :command

    def initialize(command, *args)
      @command = command
      @args = args
    end

    def self.parse(line)
      line.chomp!
      message = new(*line.split(' '))
    end

    def [](index)
      args[index]
    end

    def to_s
      [command].concat(args).join(' ')
    end
  end
end
