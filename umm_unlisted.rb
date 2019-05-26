require 'bundler/setup'

require 'mastodon'
require 'dotenv/load'
require 'net/http'
require 'time'

MASTODON_HOST = 'https://imastodon.net'.freeze

mstdn = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: ENV['MASTODON_ACCESS_TOKEN'])

class Net::HTTP
  def initialize_new(address, port = nil)
    initialize_old(address, port)
    @read_timeout = 120
  end
  alias initialize_old initialize
  alias initialize initialize_new
end

umm_seed = rand(11)
if umm_seed.between?(1, 4)
  umm = "ss"
elsif umm_seed.between?(5, 8)
  umm = "card"
elsif umm_seed.between?(9, 10)
  umm = "osr"
end
folder = './umm_' + umm + '/'

if folder == './umm_ss/'
  toot = 'うみみ…'
  files = Dir.entries('./umm_ss/')
  files.delete('.')
  files.delete('..')
  file = files.sample
elsif folder == './umm_osr/'
  toot = 'おしり…'
  files = Dir.entries('./umm_osr/')
  files.delete('.')
  files.delete('..')
  file = files.sample
elsif folder == './umm_card/'
  toot = 'うみみ…'
  files = Dir.entries('./umm_card/')
  files.delete('.')
  files.delete('..')
  file = files.sample
end

file_path = folder + file
media = mstdn.upload_media(file_path)

mstdn.create_status(toot, media_ids: [media.id], visibility: 'unlisted')

time = Time.now
log_count = Dir.glob('./log/schedule/*.txt').count.to_s
File.open('./log/schedule/' + log_count + '.txt', mode = 'a+:utf-8:utf-8') do |log|
  log.puts(time)
  log.puts(toot)
  log.puts(file_path)
  log.puts "\n"
  if log.size >= 300
    file_no = Dir.glob('./log/schedule/*.txt').count + 1
    File.open('./log/schedule/' + file_no.to_s + '.txt', mode = 'a+:utf-8:utf-8') do |log_new|
      log_new.puts('ログ 定期')
      log_new.puts "\n"
    end
  end
end
