require 'bundler/setup'

require 'mastodon'
require 'dotenv/load'
require 'net/http'
require 'time'
require 'csv'
require 'parallel'

MASTODON_HOST = 'https://imastodon.net'.freeze

mstdn = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: ENV['MASTODON_ACCESS_TOKEN'])


date = Date.today
today = date.month.to_s + '/' + date.day.to_s

options = {
  headers: true,
  encoding: 'SJIS:UTF-8'
}

csv = CSV.read('Birthday.csv', options)
result = csv.select { |row| row.to_h if row.field?(today) }

retry_count = 0
begin
  if result.empty?
    umm_seed = rand(1..100)
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
    file_path = folder + file
  else
    result.each do |data|
      text = "#{data["Umm"]}"
      toot = text + '…'
      $file_path_1 = './birthday/' + "#{data["Name"]}" + '_1' + '.png'
      # $file_path_2 = './birthday/' + "#{data["Name"]}" + '_2' + '.png'
      # $file_path_3 = './birthday/' + "#{data["Name"]}" + '_3' + '.png'
      # $file_path_4 = './birthday/' + "#{data["Name"]}" + '_4' + '.png'
    end
  end
rescue => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

retry_count = 0
begin
  if result.empty? 
    media = mstdn.upload_media(file_path)
    mstdn.create_status(toot, media_ids: [media.id])
  else
    media_1 = mstdn.upload_media($file_path_1)
    # media_2 = mstdn.upload_media($file_path_2)
    # media_3 = mstdn.upload_media($file_path_3)
    # media_4 = mstdn.upload_media($file_path_4)
    mstdn.create_status(toot, media_ids: [media_1.id])
  end
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end