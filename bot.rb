require 'cinch'
require 'time'

# Reset interruption counter if this timeout (in seconds) is exceeded.
INTERRUPTION_TIMEOUT = 30

class WhatUpWithThat
  include Cinch::Plugin

  def initialize(*args)
    super
    @num_interruptions = 0
    @last_interruption_time = Time.new
  end

  match /(.+)/, use_prefix: false

  def execute(m, message)
    this_interruption_time = Time.new
    if this_interruption_time - @last_interruption_time >= INTERRUPTION_TIMEOUT
      debug "Reseting interruption counter due to time out."
      @num_interruptions = 0
    end

    if @num_interruptions == 0 then
      m.reply "#{message}..."
      @num_interruptions += 1
    elsif @num_interruptions == 1 then
      m.reply "#{message}, yeah!"
      @num_interruptions += 1
    else
      m.reply "#{message}, baby. And I've got to say...!"
      m.reply "Oooooo-eeeeee!"
      m.reply "What up with that? What's up with that?"
      @num_interruptions = 0
    end

    @last_interruption_time = Time.new
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
