module GangOfFour
  class Cli
    attr_reader :advertiser, :client, :discoverer, :name, :opponent, :server, :state, :stdin, :stdout

    def initialize(stdin, stdout)
      @stdin, @stdout = stdin, stdout
      @discoverer = Discoverer.new
      @state = nil
    end

    def start
      #discoverer.discover

      loop do
        case state
        when nil
          ask_user_for_name
        when :named
          ask_user_create_or_join_game
        when :join_game
          #choose_an_opponent
          puts 'choose an opponent'
          exit
        when :create_game
          create_game
        when :waiting_for_opponent
        when :ready_to_start
          # turn off discoverer
          # turn off advertiser
        end
      end
    end

    private
      def ask_user_create_or_join_game
        choose = true

        while choose
          stdout.puts 'Create a game or join a game?'
          stdout.puts ' 1. Create'
          stdout.puts ' 2. Join'

          case stdin.gets.to_i
          when 1
            @state = :create_game
            choose = false
          when 2
            @state = :join_game
            choose = false
          end
        end
      end

      def ask_user_for_name
        stdout.puts %(What's your name?)
        @name = stdin.gets.chomp
        @state = :named
      end

      def choose_an_opponent
        opponents = Hash[discoverer.opponents.map.with_index { |opponent, i|
          [i + 1, opponent]
        }]

        if opponents.any?
          while opponent.nil?
            stdout.puts 'Choose an opponent or press "r" to refresh list'

            opponents.each do |number, opponent|
              stdout.puts "#{number}. #{opponent.name}"
            end

            choice = stdin.gets.chomp

            if choice == 'r'
              break
            else
              number = choice.to_i

              if opponents.has_key?(number)
                @opponent = opponents[number]
                @state = :opponent_chosen
              end
            end
          end
        else
          stdout.puts 'Looking for more opponents...'
          sleep 1
        end
      end

      def create_game
        @server = Server.new
        server.run

        @client = Client.new(server)
        client.login

        stdout.puts "You are player #{client.player_id}"

        client.on_event do |name, args|
          @state = :ready_to_start
        end

        @advertiser = Advertiser.new(server, name)
        advertiser.advertise

        @state = :waiting_for_opponent
      end
  end
end
