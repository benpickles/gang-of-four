module GangOfFour
  class Client
    attr_reader :player_id, :server

    def initialize(server)
      @server = server
    end

    def login
      @player_id = gets[0].to_i
    end

    def on_event(&block)
    end

    private
      def gets
        Message.parse(socket.gets)
      end

      def puts(message)
        socket.puts message.to_s
      end

      def socket
        @socket ||= TCPSocket.new(server.host, server.port)
      end
  end
end
