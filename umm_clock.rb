require 'bundler/setup'

require 'mastodon'
require 'net/http'
require 'time'
require 'csv'
require 'clockwork'

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

def umm_cmn(category, visibility)
  case category
  when 'ss', 'card'
    toot = 'うみみ…'
  when 'osr'
    toot = 'おしり…'
  end
  files = Dir.entries('./' + category + '/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  begin 
    media = mstdn.upload_media(file_path)
    mstdn.create_status(toot, media_ids: [media.id], visibility: visibility)
  rescue StandardError => e
    retry_count += 1
    retry if retry_count <= 3
    p e
  end
end

def birthday(category)

end

every(1.hour, 'lsited') do
  umm_seed = rand(1..100)
  if umm_seed <= ENV['osr'].to_i
    umm = 'osr'
  else
    umm = ['ss', 'card'].sample
  end
  umm_cmn(umm, listed)
end

every(1.hour, 'unlsited', at: ['**:15', '**:30', '**:45']) do
  umm_seed = rand(1..100)
  if umm_seed <= ENV['osr'].to_i
    umm = 'osr'
  else
    umm = ['ss', 'card'].sample
  end
  umm_cmn(umm, unlisted)
end