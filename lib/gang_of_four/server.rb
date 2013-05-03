module GangOfFour
  class Server
    attr_reader :game, :server

    def initialize
      @game = Game.new
      @server = TCPServer.new('0.0.0.0', 0)
      @mutex = Mutex.new
    end

    def host
      server.addr[2]
    end

    def port
      server.addr[1]
    end

    def run
      Thread.abort_on_exception = true

      Thread.new(@mutex) do |mutex|
        loop do
          connection = Connection.new(server.accept)

          Thread.new(mutex) do |mutex|
            player_id = nil

            mutex.synchronize do
              player_id = game.add_player
            end

            connection.player(player_id)

            loop do
              request = connection.gets

              if request
                message = Message.parse(request)

                case message.command
                when Message::DROP
                  error = nil

                  mutex.synchronise do
                    error = game.drop(player_id, message[0])
                  end

                  if error
                    connection.error(error)
                  else
                    connection.ok
                  end
                end
              else
                connection.close
                break
              end
            end
          end
        end
      end
    end
  end
end
