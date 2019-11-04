# frozen_string_literal: true

# Check site
class Check
  attr_reader :from, :psw, :to, :uri1, :uri2

  require 'net/http'
  require 'mail'
  
  def initialize(*args)
    @from = args[0]
    @psw = args[1]
    @to = args[2]
    @status = 200
    @uri1 = URI('https://pokupon.ua/')
    @uri2 = URI('https://partner.pokupon.ua/')
  end

  def send_mail(subj)
    options = { address: 'smtp.ukr.net',
                port: 465,
                domain: 'mail.ukr.net',
                user_name: from,
                password: psw,
                ssl: true }

    Mail.defaults { delivery_method :smtp, options }
    mail = Mail.new(to: to, from: from, subject: subj)
    mail.deliver!
  end

  def get_response(uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(Net::HTTP::Get.new(uri))
    end
    response.code
  end

  def call
    code = [get_response(uri1).to_i, get_response(uri2).to_i].max

    if @status == 200 && code != 200
      send_mail("ERROR! Status #{code}")
    elsif @status != 200 && code == 200
      send_mail("OK! Status #{code}")
    end

    @status = code if code != @status
  end
end

if ARGV.length < 3 || ARGV.length > 3
  puts 'Check parameters!'
  puts 'Example: ruby start.rb rb@ukr.net password123 mailto@gmail.com'
  exit
end

$PROGRAM_NAME = 'rubydaemon'

pid_file = File.open('pid.txt', 'w')

Process.daemon
pid = Process.pid

pid_file.write pid
pid_file.close

check_now = Check.new(ARGV[0], ARGV[1], ARGV[2])
loop do
  check_now.call
  Signal.trap('INT') { exit }
  sleep 60
end
