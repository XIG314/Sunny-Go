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

retry_count = 0

begin
  umm_seed = rand(1..100)
  time = Time.now.to_s
  res = Net::HTTP.get(URI.parse('https://api.matsurihi.me/mltd/v1/events?at=' + time))
  hash = JSON.parse(res)
  event = hash[0]
  if event["type"] == 9
    toot = 'うみみ…'
    folder = './showtime/'
    files = Dir.entries('./showtime/')
    files.delete('.')
    files.delete('..')
    file = files.sample
  elsif  event["type"] == 6
    toot = 'うみみ…'
    folder = './working/'
    files = Dir.entries('./working/')
    files.delete('.')
    files.delete('..')
    file = files.sample
  else
    if umm_seed <= ENV['osr'].to_i
      umm = 'osr'
    else
      umm = ['ss', 'card'].sample
    end
    folder = './umm_' + umm + '/'
    case umm
    when 'ss'
      toot = 'うみみ…'
      files = Dir.entries('./umm_ss/')
      files.delete('.')
      files.delete('..')
      file = files.sample
    when 'osr'
      toot = 'おしり…'
      files = Dir.entries('./umm_osr/')
      files.delete('.')
      files.delete('..')
      file = files.sample
    when 'card'
      toot = 'うみみ…'
      files = Dir.entries('./umm_card/')
      files.delete('.')
      files.delete('..')
      file = files.sample
    end
  end
  rescue StandardError => e
    retry_count += 1
    retry if retry_count <= 3
    p e
  end

file_path = folder + file

retry_count = 0
begin 
  media = mstdn.upload_media(file_path)
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

retry_count = 0
begin
  mstdn.create_status(toot, media_ids: [media.id])
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end