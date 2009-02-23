# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared_page_spec'
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
    @instance.should respond_to(:name=)

    @instance.name.should be_nil
    @instance.name = "Hello World"
    @instance.name.should == "Hello World"

    lambda {
      @instance.name = Object.new
    }.should raise_error(ArgumentError)
  end

  it "should have an current? method" do
    @instance.controller = "DummyController"

    @instance.should be_current(DummyController)
    @instance.should be_current(DummyController.new)
    @instance.should_not be_current(ApplicationController.new)
  end

  it "should have a link accessor" do
    @instance.should respond_to(:link=)

    @instance.link = "hello world"
    @instance.link(mock "Obj").should == "hello world"
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

  it "should have a translatable_name accessor" do
    @instance.should respond_to(:translatable_name)
    @instance.should respond_to(:translatable_name=)

    @instance.translatable_name = "hello world"
    @instance.translatable_name.should == "hello world"
  end

  it "should call correctly I18n.t when handling translatable names" do
    I18n.should_receive(:t).with(:"hello").and_return("hello world")
    @instance.translatable_name = :"hello"
    @instance.name.should == "hello world"
  end

  it "should alias :t_name with :translatable_name" do
    @instance.should respond_to(:t_name)
    @instance.should respond_to(:t_name=)

    @instance.t_name = "hello world"
    @instance.translatable_name.should == "hello world"

    @instance.translatable_name = "booh"
    @instance.t_name.should == "booh"
  end

  it { @instance.should respond_to(:visible_block) }

  it "should allow to specify a block that will be called to check " +
    "if this page is visible" do
    
    obj = mock "Object"

    dummy = mock "Dummy"
    dummy.should_receive(:visible?).with(obj).twice.and_return(true,false)

    @instance.visible_block do |o|
      dummy.visible? o
    end
    
    @instance.should be_visible(obj)
    @instance.should_not be_visible(obj)
  end
end

describe StaticPage, " (initalized)" do

  it_should_behave_like "a navigable page"

  before(:each) do
    @instance = StaticPage.new
    @instance.name = "Hello World"
    @instance.link = "a link"
    @instance.controller = DummyController
  end
end