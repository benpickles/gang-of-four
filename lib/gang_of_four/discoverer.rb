module GangOfFour
  require 'dnssd'

  class Discoverer
    attr_accessor :opponents

    def initialize
      @browser = DNSSD::Service.new
      @opponents = []
    end

    def discover
      services = {}

      @browser.browse '_gang_of_four._tcp' do |reply|
        services[reply.fullname] = reply
        next if reply.flags.more_coming?

        services.sort_by do |_, service|
          [(service.flags.add? ? 0 : 1), service.fullname]
        end.each do |_, service|
          next unless service.flags.add?

          DNSSD::Service.new.resolve service do |r|
            @opponents << GangOfFour::Opponent.new(r.name, r.target, r.port)
            puts "Discovered #{r.name} on #{r.target}:#{r.port}"
            puts "\t#{r.text_record.inspect}" unless r.text_record.empty?
            break unless r.flags.more_coming?
          end
        end
      end
    end
  end
end
