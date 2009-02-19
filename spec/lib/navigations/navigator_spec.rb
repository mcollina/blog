# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'
require 'navigations'

include Navigations

class DummyController < ApplicationController
end

describe Navigator do
  before(:each) do
    @instance = Navigator.new(:a_navigator)
  end

  it "should have a name" do
    @instance.should respond_to(:name)
    @instance.name.should == :a_navigator
  end
  
  it "should have a pages method" do
    @instance.should respond_to(:pages)
    @instance.pages.should == []
  end
  
  it "should have a page method" do
    @instance.should respond_to(:page)
    @instance.page("First", DummyController)
    @instance.pages.size.should == 1
    
    page = @instance.pages.first
    page.name.should == "First"
    page.controller.should == DummyController
  end

  it "should have a page method that accept a block" do
    @instance.should respond_to(:page)
    @instance.page do |p|
      p.name = "First"
      p.controller = DummyController
    end
    @instance.pages.size.should == 1

    page = @instance.pages.first
    page.name.should == "First"
    page.controller.should == DummyController

    @instance.page("Second", DummyController) do |p|
      p.name.should == "Second"
      p.controller.should == DummyController
    end

    @instance.pages.size.should == 2
  end

  it "should have a page method that add multiple pages" do
    @instance.page("First", DummyController)
    @instance.pages.size.should == 1

    @instance.page("Second", DummyController) do |p|
      p.name.should == "Second"
      p.controller.should == DummyController
    end

    @instance.pages.size.should == 2
  end

  it "should have a page method that raise an exception if no block and no args are given" do
    lambda {
      @instance.page
    }.should raise_error(ArgumentError)
  end

  it "can be anonymous" do
    @instance = Navigator.new
    @instance.name.should == :anonymous
  end

  it { @instance.should respond_to(:page_factory) }

  it "should check if a factory respond to :expand when adding factories" do
    factory = mock "factory"
    factory.should_receive(:respond_to?).with(:expand).and_return(true)

    lambda {
      @instance.page_factory(factory)
    }.should_not raise_error

    other = mock "other"
    lambda {
      @instance.page_factory(other)
    }.should raise_error(ArgumentError)
  end

  it "should have a pages method that handles correctly factories" do
    factory = mock "factory"
    factory.should_receive(:respond_to?).with(:expand).twice.and_return(true)

    page1 = mock "Page1"
    page2 = mock "Page2"
    factory.should_receive(:expand).and_return([page1,page2])

    @instance.page("First", DummyController)
    @instance.page_factory(factory)
    @instance.page("Second", DummyController)

    pages = @instance.pages
    pages.size.should == 4
    pages[1].should == page1
    pages[2].should == page2
  end
end