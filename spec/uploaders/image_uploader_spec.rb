require 'rails_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:user) { create :user }
  let(:uploader) { ImageUploader.new user, :image }

  before do
    ImageUploader.enable_processing = true
    File.open('spec/uploaders/images/image.jpg') { |f| uploader.store! f }
  end

  after do
    ImageUploader.enable_processing = true
    uploader.remove!
  end

  context 'original' do
    it '360x360' do
      expect(uploader).to have_dimensions 360, 225
    end
  end

  context 'tiny version' do
    it '30x30' do
      expect(uploader.tiny).to have_dimensions 30, 19
    end
  end
end
