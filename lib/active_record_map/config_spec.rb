require 'map'
require 'active_model'
require 'minitest/autorun'
require_relative 'config'

##
# ActiveRecord mocks
#
class Column
  attr_accessor :name, :type

  def initialize(name, type)
    @name, @type = name, type
  end
end

class TesteThong
  attr_accessor :title, :details
  include ActiveModel
  extend ActiveRecordMap::Config

  def self.columns
    [Column.new(:title, :string), Column.new(:details, :json)]
  end
end

describe ActiveRecordMap::Config do
  describe '.use(class_name :str, attribute_name :sym)' do

    subject{ TesteThong }
    let(:filter){ 'MyFilter' }

    before do
      subject.use filter, :details
    end

    it 'stores attribute_name as key and class_name as val' do
      subject.config[:map_filters]['details'].must_equal filter
    end

    it 'contains all the multi-method-of-access glory of Map' do
      subject.config.map_filters.details.must_equal filter
      subject.config.map_filters[:details].must_equal filter
      subject.config['map_filters'].details.must_equal filter
    end
  end
end
