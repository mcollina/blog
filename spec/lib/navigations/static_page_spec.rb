# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'
require 'navigations'

include Navigations

class DummyController < ApplicationController
end

describe StaticPage do
  before(:each) do
    @instance = StaticPage.new
  end

  it "should have a controller accessor" do
    @instance.should respond_to(:controller)
    @instance.should respond_to(:controller=)

    @instance.controller.should be_nil
    @instance.controller = "DummyController" # the class name
    @instance.controller.should == DummyController


    @instance.controller = "Hello World"
    lambda {
      @instance.controller
    }.should raise_error
  end

  it "should have a name accessor" do
    @instance.should respond_to(:name)
    @instance.should respond_to(:name=)

    @instance.name.should be_nil
    @instance.name = "Hello World"
    @instance.name.should == "Hello World"

    lambda {
      @instance.name = Object.new
    }.should raise_error(ArgumentError)
  end

  it "should have an current? method" do
    @instance.should respond_to(:current?)

    @instance.controller = "DummyController"

    @instance.should be_current(DummyController)
    @instance.should be_current(DummyController.new)
    @instance.should_not be_current(ApplicationController.new)
  end
end

