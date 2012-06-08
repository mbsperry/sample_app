# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Exmaple User", email: "user@example.com",
                       password: "foobar", password_confirmation: "foobar") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when passwords doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when the confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "email should be present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "email should have the right format" do
    before { @user.email = "foo@foo,com" }
    it { should_not be_valid }
  end

  describe "common email addresses should be allowed" do
    it "should be valid" do
      addresses = %w[user@test.COM a_us_er@te.st.org first.last@test.net]
      addresses.each do |address|
        @user.email = address
        @user.should be_valid
      end
    end
  end

  describe "when email address is not unique" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when email is not downcased in the database" do
    before do
      @user.email = "UPPER@CASE.COM"
      @user.save 
    end

    specify { @user.reload.email.should_not == "UPPER@CASE.COM" }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
end

