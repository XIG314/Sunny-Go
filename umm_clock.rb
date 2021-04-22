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

def birthday(idol)
  result = idol

  result.each do |data|
    text = "#{data["Umm"]}"
    toot = text + '…'
    $file_path_1 = './birthday/' + "#{data["Name"]}" + '_1' + '.png'
    $file_path_2 = './birthday/' + "#{data["Name"]}" + '_2' + '.png'
    $file_path_3 = './birthday/' + "#{data["Name"]}" + '_3' + '.png'
    $file_path_4 = './birthday/' + "#{data["Name"]}" + '_4' + '.png'
  end

  retry_count = 0
  begin
    media_1 = mstdn.upload_media($file_path_1)
    media_2 = mstdn.upload_media($file_path_2)
    media_3 = mstdn.upload_media($file_path_3)
    media_4 = mstdn.upload_media($file_path_4)
    mstdn.create_status(toot, media_ids: [media_1.id, media_2.id, media_3.id, media_4.id])
  rescue StandardError => e
    retry_count += 1
    retry if retry_count <= 3
    p e
  end
end

handler do |job|
  case job
  when 'listed'
    umm_seed = rand(1..100)
    if umm_seed <= ENV['osr'].to_i
      umm = 'osr'
    else
      umm = ['ss', 'card'].sample
    end
    umm_cmn(umm, listed)
  when 'unlisted'
    umm_seed = rand(1..100)
    if umm_seed <= ENV['osr'].to_i
      umm = 'osr'
    else
      umm = ['ss', 'card'].sample
    end
    umm_cmn(umm, unlisted)
  when 'birthday'
    csv = CSV.read('Birthday.csv', options)
    result = csv.select { |row| row.to_h if row.field?(today) }
    if result.empty?
      umm_seed = rand(1..100)
      if umm_seed <= ENV['osr'].to_i
        umm = 'osr'
      else
        umm = ['ss', 'card'].sample
      end
      umm_cmn(umm, listed)
    else
      birthday(result)
    end
  end
end

every(1.hour, 'lsited', at:['1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00'])

every(1.hour, 'unlsited', at: ['**:15', '**:30', '**:45'])

every(1.day, 'birthday', at: '00:00')

every(1.day, 'event', at: '23:00')