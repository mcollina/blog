require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'thread_locals'

describe ThreadLocals do

  after(:each) do
    begin
      ThreadLocals.destroy
    rescue
    end
  end


  it "should be able to store some variables" do
    ThreadLocals.var = "Hello"
    ThreadLocals.var.should == "Hello"
  end

  it "should be able to destory the contained data" do
    ThreadLocals.another_var = "Hello"
    ThreadLocals.destroy
    ThreadLocals.another_var.should be_nil
  end

  it "should be local to the current thread" do
    ThreadLocals.var = "a var"

    var = "hello"
    thread = Thread.new do
      var = ThreadLocals.var
    end

    thread.join
    var.should be_nil
  end

  it "shouldn't accept arguments with normal methods" do
    lambda {
      ThreadLocals.ghgh("hello world")
    }.should raise_error(ArgumentError)
  end
end

