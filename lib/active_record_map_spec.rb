require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'
require 'minitest/autorun'
require_relative 'active_record_map'

class TestDb

  include ActiveRecord::Tasks

  def self.test_creds
    {
      'adapter' => 'postgresql',
      'host' => 'localhost',
      'username' => ENV['USER'],
      'database' => 'active_record_map_test',
      'schema_search_path' => 'public'
    }
  end

  def self.create
    ActiveRecord::Tasks::DatabaseTasks.create(test_creds)
    ActiveRecord::Base.establish_connection(test_creds)
  end

  def self.drop
    ActiveRecord::Tasks::DatabaseTasks.drop(test_creds)
  end
end

connection = TestDb.create

ActiveRecord::Schema.define do

  create_table :real_thangs, force: true do |t|
    t.string :title
    t.json :details
  end

end

class RealThang < ActiveRecord::Base; end

describe ActiveRecordMap do
  before do
    ActiveRecord::Base.connected?.must_equal true
  end
  # smoke signals!!
  it 'exists as a top-level module' do
    ::ActiveRecordMap.must_be_kind_of Module
  end

  describe 'sub classes' do
    describe 'ActiveRecordMap::Map' do
      it 'is a kind of ::Map' do
        ::ActiveRecordMap::Map.new.must_be_kind_of ::Map
      end

      it 'redefines Map#method_missing to return ruby arrays from stringified JSON' do
        json_a = { "items" => "[\"item one\",\"item two\"]" }
        active_record_map = ActiveRecordMap::Map.new json_a
        active_record_map.items.must_be_kind_of Array
      end

      it 'redefined Map#method_missing to return ruby hashes from stringified JSON' do
        json_h = { "person" => "{\"name\": \"Charlie\", \"address\": \"123 Main St\"}" }
        active_record_map = ActiveRecordMap::Map.new json_h
        #active_record_map.person.name.must_equal "Charlie"
        active_record_map.person.must_be_kind_of Hash
      end
    end
  end

  describe 'sub modules' do
    it 'ActiveRecordMap::Config is defined' do
      ::ActiveRecordMap::Config.must_be_kind_of Module
    end

    it 'ActiveRecordMap::AfterInitializeHook is defined' do
      ::ActiveRecordMap::AfterInitializeHook.must_be_kind_of Module
    end
  end

  describe 'USAGE' do
    describe '1. Setup' do
      before do
        RealThang.send :include, ActiveRecordMap
      end
      it '1a. `include ActiveRecordMap` to a descendant of ActiveRecord::Base that has an json column type' do
        # todo: there is probably a better way to test USAGE 1a ...

        RealThang.ancestors.must_include ActiveRecordMap
      end

      it '1b. Create and use custom map class; it should inherit from ActiveRecordMap::Map' do
        class MyMap < ActiveRecordMap::Map; end

        RealThang.use 'MyMap', :details
        RealThang.new.details.must_be_kind_of MyMap
      end

      it 'note: As an alternative to 1b, just use ActiveRecordMap::Map' do
        RealThang.use 'ActiveRecordMap::Map', :details
        RealThang.new.details.must_be_kind_of ActiveRecordMap::Map
      end

      it 'note: When only one json column is used, it is not necessary to supply it as an argument to .use()' do
        RealThang.use 'ActiveRecordMap::Map'
        RealThang.new.details.must_be_kind_of ActiveRecordMap::Map
      end
    end

    describe '2. Enjoy the multi-access glory that is Map' do
      let(:real_thang) do
        RealThang.send :include, ActiveRecordMap
        RealThang.use 'ActiveRecordMap::Map'
        RealThang.new
      end
      let(:title){ 'All Things Worth Knowing' }
      let(:intro){ 'The following caveats are in all likelihood worth knowing but they are not covered here.' }
      let(:caveats){ ['Measuring Program(mer) Value/Effectiveness', 'Cause and Effect', 'Logic'] }
      let(:references){ {'a' => 'How To: Write a Useless Book', 'b' => 'Increasing Trouble While Decreasing Productivity'}.to_json }

      it 'saves and reads data accurately' do
        real_thang.title = title
        real_thang.details = {
          intro: intro,
          caveats: caveats,
          references: references
        }
        real_thang.save!
        real_thang.reload

        real_thang.title.must_equal title
        real_thang.details[:intro].must_equal intro
        real_thang.details.caveats.must_equal caveats
        real_thang.details.references.must_be_kind_of Hash
        real_thang.details['references'].must_equal references
      end

    end
  end
end

#Minitest.after_run{ TestDb.drop } # => NoMethodError
#at_exit { TestDb.drop } # => runs prematurely (before tests execute)