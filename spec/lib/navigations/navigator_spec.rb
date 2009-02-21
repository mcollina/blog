# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'
require 'navigations'

include Navigations

class DummyController < ApplicationController
end

describe Navigator do

  def mock_page(name)
    page = mock "Page #{name}"
    page.should_receive(:name).any_number_of_times.and_return(name)
    page.should_receive(:controller).any_number_of_times.and_return(DummyController)

    {
      :current? => true,
      :name => true,
      :expand => false
    }.each do |method, result|
      page.should_receive(:respond_to?).any_number_of_times.with(method).and_return(result)
    end
  end

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

  it { @instance.should respond_to(:page) }
  
  it "should have a page method that accept a page" do
    page = mock_page("First")

    @instance.page(page)
    @instance.pages.should == [page]
  end

  it "should have a page method that accept a block" do
    @instance.page do |p|
      p.should be_kind_of(StaticPage)
      p.name = "First"
      p.controller = DummyController
    end
    @instance.pages.size.should == 1

    page = @instance.pages.first
    page.name.should == "First"
    page.controller.should == DummyController
  end

  it "should have a page method that add multiple pages" do
    @instance.page do |p|
      p.name = "First"
      p.controller = DummyController
    end
    @instance.pages.size.should == 1

    @instance.page do |p|
      p.name = "Second"
      p.controller = DummyController
    end

    @instance.pages.size.should == 2
  end

  it "should have a page method that raise an exception if no block and no page are given" do
    lambda {
      @instance.page
    }.should raise_error(ArgumentError)
  end

  it "can be anonymous" do
    @instance = Navigator.new
    @instance.name.should == :anonymous
  end

  it { @instance.should respond_to(:page_factory) }

  it "should check if a factory respond to :expand when adding page factories" do
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

  it "should add a page factory by passing a block" do
    page1 = mock "Page1"
    page2 = mock "Page2"

    lambda {
      @instance.page_factory { [page1, page2] }
    }.should_not raise_error

    @instance.pages.should == [page1,page2]
  end

  it "should have a page_factory method that raise an exception if no block and no factory are given" do
    lambda {
      @instance.page_factory
    }.should raise_error(ArgumentError)
  end

  it "should have a pages method that handles correctly factories" do
    factory = mock "factory"
    factory.should_receive(:respond_to?).with(:expand).twice.and_return(true)

    page1 = mock "Page1"
    page2 = mock "Page2"
    factory.should_receive(:expand).and_return([page1,page2])

    @instance.page(mock_page("First"))
    @instance.page_factory(factory)
    @instance.page(mock_page("Second"))

    pages = @instance.pages
    pages.size.should == 4
    pages[1].should == page1
    pages[2].should == page2
  end
end