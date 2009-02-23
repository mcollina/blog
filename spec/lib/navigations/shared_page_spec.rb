# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "a navigable page", :shared => true do

  it { @instance.should respond_to(:current?) }

  it { @instance.should respond_to(:link) }

  it { @instance.should respond_to(:name) }

  it "should have a link method that accept a binding" do
    lambda {
      @instance.link(binding).should_not be_nil
    }.should_not raise_error
  end

  it "should have a link method that accept an object" do
    lambda {
      @instance.link(self).should_not be_nil
    }.should_not raise_error
  end
end

