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
end