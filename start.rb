require 'net/http'
require 'uri'
require 'mail'

def send_mail(subj)
  options = { address: 'smtp.ukr.net',
              port: 465,
              domain: 'mail.ukr.net',
              user_name: @from,
              password: @psw,
              authentication: 'login',
              ssl: true }

  Mail.defaults do
    delivery_method :smtp, options
  end

  mail = Mail.new
  mail.to = @to
  mail.from = @from
  mail.subject = subj

  # p mail.delivery_method.settings.to_s
  mail.deliver!
end

def getresponse(uri)
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(Net::HTTP::Get.new(uri.path)) }
  response.code
end

def test_
  code1 = getresponse @uri1
  # p 'Status URL1: ' + code1

  code2 = getresponse @uri2
  # p 'Status URL2: ' + code2

  # the response code must be >= 200
  code = [code1.to_i, code2.to_i].max.to_s

  if (@status == '200' || @status.nil?) && code != '200'
    # p 'Last status: ' + @status
    # p 'Send msg ERR'
    send_mail('ERROR! Status ' + code)
  elsif (@status != '200' && !@status.nil?) && code == '200'
    # p 'Last status: ' + @status
    # p 'Send msg OK'
    send_mail('OK! Status ' + code)
  end

  @status = code if code != @status
  # p '-----------------'
end

if ARGV.length < 3
  puts 'Too few arguments | недостаточно параметров'
  puts 'Пример: ruby start.rb rb@ukr.net password123 mailto@gmail.com'
  exit
end

@from = ARGV[0]
@psw = ARGV[1]
@to = ARGV[2]

@uri1 = URI.parse('https://pokupon.ua/')
@uri2 = URI.parse('https://partner.pokupon.ua/')

fork do
  loop do
    test_
    sleep 15
    # exit!(1) if
  end
end
