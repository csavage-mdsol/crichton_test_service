require 'crichton/representor'

class DrdsDecorator
  puts "OVER HERE"
  puts Crichton.inspect
  puts Crichton::Representor.inspect
  puts Crichton::Representor::Factory.inspect
  puts Crichton
  puts Crichton::Representor
  puts Crichton::Representor::Factory
  puts "NOT HERE"
  include Crichton::Representor::Factory

  attr_reader :collection, :controller

  def initialize(collection, controller)
    @controller = controller
    @collection = collection
  end

  def value
    drds_collection = { items: collection, total_count: collection.size }

    build_state_representor(drds_collection, :drds, options )
  end

  def state
    controller.params[:search] ? :navigation : :collection
  end

  def options
    {state: state}
  end
end
