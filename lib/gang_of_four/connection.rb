module GangOfFour
  class Connection
    CRLF = "\r\n"

    DROP = 'DROP'
    ERROR = 'ERROR'
    OK = 'OK'
    PLAYER = 'PLAYER'

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def close
      client.close
    end

    def error(text)
      puts Message.new(ERROR, text)
    end

    def gets
      client.gets(CRLF)
    end

    def ok
      puts Message.new(OK)
    end

    def player(id)
      puts Message.new(PLAYER, id)
    end

    def puts(message)
      client.write(message.to_s)
      client.write(CRLF)
    end
  end
end
