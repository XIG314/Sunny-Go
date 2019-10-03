require 'bundler/setup'

require 'mastodon'
require 'dotenv/load'
require 'net/http'
require 'time'
require 'csv'

MASTODON_HOST = 'https://imastodon.net'.freeze

mstdn = Mastodon::REST::Client.new(base_url: MASTODON_HOST, bearer_token: ENV['MASTODON_ACCESS_TOKEN'])

umm = ['ss', 'osr']
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
    file_path = folder + file
  else
    result.each do |data|
      text = "#{data["Umm"]}"
      toot = text + '…'
      file = "#{data["Name"]}" + '.png'
    end
    file_path = './birthday/' + file
  end
rescue => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

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