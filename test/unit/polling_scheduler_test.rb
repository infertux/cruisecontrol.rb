require 'date'
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PollingSchedulerTest < Test::Unit::TestCase

  def setup
    @mock_project = Object.new
    @scheduler = PollingScheduler.new(@mock_project)
  end

  def test_polling_interval_default_value_and_overriding
    assert_equal Configuration.default_polling_interval, @scheduler.polling_interval
    @scheduler.polling_interval = 1.minute
    assert_equal 60, @scheduler.polling_interval
  end

  def test_polling_interval_limits
    assert_nothing_raised { @scheduler.polling_interval = 5.seconds }
    assert_raises("Polling interval of 4 seconds is too small (min. 5 seconds)") do
      @scheduler.polling_interval = 4.seconds
    end
    assert_nothing_raised { @scheduler.polling_interval = 24.hours }
    assert_raises("Polling interval of 86401 seconds is too big (max. 24 hours)") do
      @scheduler.polling_interval = 24.hours + 1.second
    end
  end

  def test_memento
    assert_nil @scheduler.memento
    
    @scheduler.polling_interval = 5.minutes
    assert_equal "  project.scheduler.polling_interval = 300.seconds", @scheduler.memento
  end

end