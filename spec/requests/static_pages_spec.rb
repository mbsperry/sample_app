require 'spec_helper'

describe "StaticPages" do

  subject { page }

	describe "Home page" do
    before { visit root_path }

		it { should have_selector('h1', :text => 'Sample App') }
		it { should have_selector('title', text: "Ruby on Rails Tutorial") }
    it { should_not have_select 'title', text: '| Home' }
  end

	describe "Help page" do
    before { visit help_path }
		it { should have_selector('h1', :text => 'Help') }
		it { should have_selector('title',
											:text => " | Help") }
	end

	describe "About Page" do
    before { visit about_path }
		it { should have_selector('h1', :text => 'About Us') }
		it { should have_selector('title',
											:text => " | About Us") }
	end

  describe "Contact Page" do
    before { visit help_path }
		it { should have_selector('h1', :text => 'Help') }
		it { should have_selector('title',
											:text => " | Help") }
	end
end
