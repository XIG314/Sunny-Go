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
  umm_seed = rand(101)
  if umm_seed.between?(1, 50)
    umm = "ss"
  elsif umm_seed.between?(51, 97)
    umm = "card"
  elsif umm_seed.between?(98, 100)
    umm = "osr"
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
rescue => e
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
  mstdn.create_status(toot, media_ids: [media.id], visibility: 'unlisted')
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end
