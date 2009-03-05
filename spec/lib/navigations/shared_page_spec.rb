# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "a navigable page", :shared => true do

  it { @instance.should respond_to(:current?) }

  it { @instance.should respond_to(:link) }

  it { @instance.should respond_to(:name) }

  it { @instance.should respond_to(:visible?) }

  it "should be visible or not" do
    visible = @instance.visible?(Object.new)

    if visible
      visible.should === true
    else
      visible.should === false
    end
  end

  it "shouldn't be current with a random object" do
    @instance.should_not be_current(Object.new)
  end

  it "should have a link_options method that returns an hash" do
    @instance.should respond_to(:link_options)
    @instance.link_options.should be_kind_of(Hash)
  end
end

