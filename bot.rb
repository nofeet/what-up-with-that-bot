require 'cinch'
require 'time'

class WhatUpWithThat
  include Cinch::Plugin

  def initialize(*args)
    super
    @num_interuptions = 0
    @last_interuption_time = Time.new
  end

  match /(.+)/, use_prefix: false

  def execute(m, message)
    this_interuption_time = Time.new
    if this_interuption_time - @last_interuption_time >= 30
      # if it has been more than 30 seconds since last interuption, start over.
      @num_interuptions = 0
    end
    if @num_interuptions == 0 then
      m.reply "#{message}..."
    elsif @num_interuptions == 1 then
      m.reply "#{message}, yeah!"
    else
      m.reply "#{message}, baby. And I've got to say...!"
      m.reply "Oooooo-eeeeee!"
      m.reply "What up with that? What's up with that?"
      @num_interuptions = 0
    end
    @num_interuptions += 1
    @last_interuption_time = Time.new
  end

end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "DeAndre_Cole"
    c.server = "irc.freenode.org"
    c.channels = ["#wuwt"]
    c.plugins.plugins = [WhatUpWithThat]
  end
end

bot.start
