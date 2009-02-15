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
  
  it "should have an add_page method" do
    @instance.should respond_to(:add_page)
    @instance.add_page("First", DummyController)
    @instance.pages.size.should == 1
    
    page = @instance.pages.first
    page.name.should == "First"
    page.controller.should == DummyController
  end
end