require 'map'
require 'active_model'
require 'minitest/autorun'
require_relative 'after_initialize_hook'

##
# ActiveRecord mocks
#
class Record
  attr_accessor :title, :details

  include ActiveModel

  def self.config; @config; end
  def self.config=(hash=Map.new); @config = hash; end

  def self.after_initialize(&block)
    @@after_initialize = block
  end
  include ActiveRecordMap::AfterInitializeHook

  def initialize(title, details)
    @title, @details = title, details

    @@after_initialize.call(self)
  end

  def [](i)
    instance_variable_get("@#{i}")
  end

  def []=(i, v)
    instance_variable_set("@#{i}", v)
  end
end

describe ActiveRecordMap::AfterInitializeHook do
  let(:config) do
    {
      map_filters: {
        details: 'ActiveRecordMap::Map'
      }
    }
  end

  before do
    Record.config = config
    @subject = Record.new('Test Record', {foo: 'fuzz', boo: 'bazz'})
  end

  it 'wraps designated attributes in the designated class' do
    @subject.details.class.to_s.must_equal config[:map_filters][:details]
  end
end
