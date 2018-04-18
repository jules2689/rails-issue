require 'test_helper'

class MyModelTest < ActiveSupport::TestCase
  setup do
    @parent = parent_models(:one)
  end

  test "works when using boolean value" do
    as_bool = @parent.my_models.all.where(my_value: true)
    assert_equal 1, as_bool.count
    assert as_bool.all?(&:my_value), 'All the my values were not true' 
  end

  test "works when using string" do
    as_string = @parent.my_models.all.where(my_value: 'true')
    assert_equal 1, as_string.count
    assert as_bool.all?(&:my_value), 'All the my values were not true' 
  end

  test "true string is evaluated to true" do
    MyModel.all.each { |m| m.update(my_value: false) }

    as_string = @parent.my_models.all.where(my_value: 'true')
    assert_equal 0, as_string.count, 'true string is evaluated to false :('
  end
end
