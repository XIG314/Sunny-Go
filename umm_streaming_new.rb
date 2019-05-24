require 'bundler/setup'

require 'mastodon'
require 'dotenv/load'
require 'net/http'
require 'json'
require 'sanitize'
require 'time'

@debug = true

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

def umm(id, reply_id, log_count)
  toot = '@' + id + ' うみみ…'
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('うみみ')
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'うみみ' if @debug
end

def umm_osr(id, reply_id, log_count)
  toot = '@' + id + ' おしり…'
  files = Dir.entries('./umm_osr/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './umm_osr/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('おしり')
    log.puts(file_path)
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'おしり' if @debug
end

def umm_onk(id, reply_id, log_count)
  toot = '@' + id + ' おなか…'
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('おなか')
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'おなか' if @debug
end

def umm_ss(id, reply_id, log_count)
  toot = '@' + id + ' うみみ…'
  files = Dir.entries('./umm_ss/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './umm_ss/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('スクショ')
    log.puts(file_path)
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'スクショ' if @debug
end

def umm_card(id, reply_id, log_count)
  toot = '@' + id + ' うみみ…'
  files = Dir.entries('./umm_card/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './umm_card/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('カード')
    log.puts(file_path)
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'カード' if @debug
end

def explosion(id, reply_id, log_count)
  toot = '@' + id
  files = Dir.entries('./explosion/')
  files.delete('.')
  files.delete('..')
  file = files.sample
  file_path = './explosion/' + file
  media = @rest.upload_media(file_path)
  @rest.create_status(toot, in_reply_to_id: [reply_id], media_ids: [media.id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('だいばくはつ')
    log.puts(file_path)
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'だいばくはつ' if @debug
end

def help(id, reply_id, log_count)
  help = File.open('./text/help.txt', 'a+:utf-8:utf-8').read
  toot = '@' + id + ' ' + help
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'unlisted')
  time = Time.now
  File.open('./log/streaming/' + log_count + '.txt', 'a+:utf-8:utf-8') do |log|
    log.puts(time)
    log.puts(id)
    log.puts('ヘルプ')
    log.puts "\n"
    if log.size >= 300
      file_no = Dir.glob('./log/streaming/*.txt').count + 1
      File.open('./log/streaming/' + file_no.to_s + '.txt', 'a+:utf-8:utf-8')
    end
  end
  puts 'ヘルプ' if @debug
end

def log_teiki(reply_id)
  toot = '@XIG_niconico '
  log_count = Dir.glob('./log/schedule/*.txt').count.to_s
  File.open('./log/schedule/' + log_count + '.txt', 'r:utf-8:utf-8') do |log|
    log.each do |line|
      toot << line
    end
  end
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'direct')
  puts 'ログ 定期'
end

def log_reply(reply_id)
  toot = '@XIG_niconico '
  log_count = Dir.glob('./log/streaming/*.txt').count.to_s
  File.open('./log/streaming/' + log_count + '.txt', 'r:utf-8:utf-8') do |log|
    log.each do |line|
      toot << line
    end
  end
  @rest.create_status(toot, in_reply_to_id: [reply_id], visibility: 'direct')
  puts 'ログ リプライ'
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
        log_counts = Dir.glob('./log/streaming/*.txt').count.to_s
        if content == 'うみみ'
          threads << Thread.start { umm(username, in_reply_to_id, log_counts) }
        elsif content == 'おしり'
          threads << Thread.start { umm_osr(username, in_reply_to_id, log_counts) }
        elsif content == 'おなか'
          threads << Thread.start { umm_onk(username, in_reply_to_id, log_counts) }
        elsif content == 'スクショ'
          threads << Thread.start { umm_ss(username, in_reply_to_id, log_counts) }
        elsif content == 'カード'
          threads << Thread.start { umm_card(username, in_reply_to_id, log_counts)}
        elsif content == 'だいばくはつ'
          threads << Thread.start { explosion(username, in_reply_to_id, log_counts) }
        elsif content == 'ヘルプ'
          threads << Thread.start { help(in_reply_to_id, log_counts) }
        elsif (content.split[0] == 'ログ') && (username == 'XIG_niconico')
          if content.split[1] == '定期'
            threads << Thread.start { log_teiki(in_reply_to_id) }
          elsif content.split[1] == 'リプライ'
            threads << Thread.start { log_reply(in_reply_to_id) }
          end
        end
      end
    end
  end
rescue StandardError => e
  p e
end
