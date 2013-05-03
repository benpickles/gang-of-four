module GangOfFour
  require 'dnssd'

  class Advertiser
    attr_reader :server, :name

    def initialize(server, name)
      @server    = server
      @name      = name
    end

    def advertise
      DNSSD.register name, '_gang_of_four._tcp', nil, server.port do |r|
        if r.flags.add?
          puts "Registered service #{r.fullname}"
        end
      end
    end
  end
end

