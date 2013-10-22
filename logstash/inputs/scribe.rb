require 'java'
require "logstash/inputs/tcp"
require "logstash/namespace"
require "logstash/event"
include Java
java_import 'scribe.thrift.ResultCode'
java_import 'scribe.thrift.Scribe'
java_import 'scribe.thrift.ActionScribeHandler'
java_import 'scribe.thrift.LogEntry'
java_import 'scribe.thrift.StdoutScribeHandler'
java_import 'scribe_server.Util'

class LogStash::Inputs::Scribe < LogStash::Inputs::Base
  class ScribeHandler < ActionScribeHandler
    #include Scribe::Iface

    #def initialize(output_queue)
      #@output_queue = output_queue
    #end

    def setQueue(output_queue)
      @output_queue = output_queue
    end

    def action(message)
        event = LogStash::Event.new({"message" => message.getMessage(), "category" => message.getCategory()})
        @output_queue << event
    end

    #java_signature 'ResultCode Log(List<LogEntry> messages)'
   # def Log(messages)
    #  messages.each do |message|
     #   event = LogStash::Event.new({"message" => message.getMessage(), "category" => message.getCategory()})
      #  @output_queue << event
      #end
      #return ResultCode.OK
    #end
  end

  class Interrupted < StandardError; end

  config_name "scribe"
  milestone 1

  #default :codec, "plain"
  config :host, :validate => :string, :default => "0.0.0.0"
  config :port, :validate => :number, :required => true
  #config :charset, :validate => ::Encoding.name_list, :default => "UTF-16"

  def initialize(*args)
    super(*args)
  end # def initialize

  public
  def register
    @logger.info("Starting scribe input listener", :address => "#{@host}:#{@port}")
  end # def register

  public
  def run(output_queue)
    #handler = ScribeHandler.new(output_queue);
    handler = ScribeHandler.new()
    handler.setQueue(output_queue)
    @logger.info("Start of run for thrift plugin")
    #Util.serveWithHandler(@host, @port, StdoutScribeHandler.new())
    Util.serveWithHandler(@host, @port, handler)
  end
end 
