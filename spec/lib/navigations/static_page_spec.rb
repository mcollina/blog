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

  it "should have a link accessor" do
    @instance.should respond_to(:link)
    @instance.should respond_to(:link=)

    @instance.link = "hello world"
    @instance.link.should == "hello world"
  end

  it "should have a link_to_eval accessor" do
    @instance.should respond_to(:link_to_eval)
    @instance.should respond_to(:link_to_eval=)

    @instance.link_to_eval = "hello world"
    @instance.link_to_eval.should == "hello world"
  end

  it "should eval the 'link_to_eval' when calling :link with a binding" do
    @instance.link_to_eval = "var"

    lambda {
      var = "hello word"
      @instance.link(binding).should == var
    }.should_not raise_error
  end
  
  it "should eval the 'link_to_eval' when calling :link with an object" do
    class MyClass
      attr_accessor :var
    end

    @instance.link_to_eval = "var"
    
    obj = MyClass.new
    obj.var = "hello world"

    lambda {      
      @instance.link(obj).should == obj.var
    }.should_not raise_error
  end
end
