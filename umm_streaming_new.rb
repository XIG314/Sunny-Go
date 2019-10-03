require 'bundler/setup'

require 'mastodon'
require 'dotenv/load'
require 'net/http'
require 'json'
require 'sanitize'
require 'csv'

@debug = false

MASTODON_HOST = 'imastodon.net'.freeze
TOKEN = ENV['MASTODON_ACCESS_TOKEN']

BASEURL = "https://#{MASTODON_HOST}".freeze

stream = Mastodon::Streaming::Client.new(
  base_url: BASEURL,
  bearer_token: TOKEN
)

@rest = Mastodon::REST::Client.new(
  base_url: BASEURL,
  bearer_token: TOKEN
)

class Net::HTTP
  def initialize_new(address, port = nil)
    initialize_old(address, port)
    @read_timeout = 120
  end
  alias initialize_old initialize
  alias initialize initialize_new
end

def umm(id, reply_id)
  toot = '@' + id + ' うみみ…'
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  puts 'うみみ' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def umm_osr(id, reply_id)
  toot = '@' + id + ' おしり…'
  files = Dir.entries('./umm_osr/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './umm_osr/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  puts 'おしり' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def umm_onk(id, reply_id)
  toot = '@' + id + ' おなか…'
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  puts 'おなか' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def umm_ss(id, reply_id)
  toot = '@' + id + ' うみみ…'
  files = Dir.entries('./umm_ss/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './umm_ss/' + file
  media = @rest.upload_media(file_path)
  puts 'スクショ' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def umm_card(id, reply_id)
  toot = '@' + id + ' うみみ…'
  files = Dir.entries('./umm_card/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './umm_card/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  puts 'カード' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def explosion(id, reply_id)
  toot = '@' + id
  files = Dir.entries('./explosion/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './explosion/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  puts 'だいばくはつ' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def help(id, reply_id)
  help = File.open('./text/help.txt', 'a+:utf-8:utf-8').read
  toot = '@' + id + ' ' + help
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  puts 'ヘルプ' if @debug
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

def dex(id, reply_id, poke)
  options = {
    headers: true,
    encoding: 'SJIS:UTF-8'
  }
  csv = CSV.read('pokemon_status.csv', options)
  pokemon_name = poke.split(" ")[1]
  result = csv.select { |row| row.to_h if row.field?(pokemon_name) }
  p result
  result.each do |data|
    no = "#{data["図鑑番号"]}"
    name = "#{data["ポケモン名"]}"
    type1 = "#{data["タイプ１"]}"
    type2 = "#{data["タイプ２"]}"
    ability1 = "#{data["通常特性１"]}"
    ability2 = "#{data["通常特性２"]}"
    dream_ability = "#{data["夢特性"]}"
    h = "#{data["HP"]}"
    a = "#{data["こうげき"]}"
    b = "#{data["ぼうぎょ"]}"
    c = "#{data["とくこう"]}"
    d = "#{data["とくぼう"]}"
    s = "#{data["すばやさ"]}"
    sum = "#{data["合計"]}"

    toot = '@' + id + ' ' + 'No.' + no + ' ' + name + ' ' + 'タイプ:' + type1 + ' ' + type2 + ' ' + '特性:' + ability1 + ' ' + ability2 + ' ' + '夢特性' + dream_ability + ' ' + 'HP:' + h + ' ' + '攻撃:' + a + ' ' + '防御:' + b + ' ' +'特攻:' + c + ' ' + '特防:' + d + ' ' + '素早さ:' + s + ' ' + '合計:' + sum 
    @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  end
  
rescue StandardError => e
  retry_count += 1
  retry if retry_count <= 3
  p e
end

threads = []

begin
  stream.user do |toot|
    if toot.is_a?(Mastodon::Notification)
      if toot.type == 'mention'
        puts '!message' if @debug
        content = toot.status.content
        content.gsub!(/<br\s?\/?>/, '')
        content.gsub!('</p><p>', '')
        content = Sanitize.clean(content).strip
        content.gsub!('@umm ', '')
        username = toot.account.username
        in_reply_to_id = toot.status.id
        case content.split(" ")[0]
        when 'おしり'
          threads << Thread.start { umm_osr(username, in_reply_to_id,) }
        when 'おなか'
          threads << Thread.start { umm_onk(username, in_reply_to_id) }
        when 'スクショ'
          threads << Thread.start { umm_ss(username, in_reply_to_id) }
        when 'カード'
          threads << Thread.start { umm_card(username, in_reply_to_id)}
        when 'だいばくはつ'
          threads << Thread.start { explosion(username, in_reply_to_id) }
        when 'ヘルプ'
          threads << Thread.start { help(username, in_reply_to_id) }
        when '図鑑'
          threads << Thread.start { dex(username, in_reply_to_id, content) }
        else
          threads << Thread.start { umm(username, in_reply_to_id) }
        end
      end
    end
  end
end
