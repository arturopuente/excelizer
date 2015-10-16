require "spec_helper"

describe Excelizer::Base do
  let(:downloader_class) { Class.new(described_class) }
  let(:collection) do
    3.times.map do |i|
      OpenStruct.new(id: i, name: "User #{i}", last_name: "Last Name #{i}")
    end
  end
  let(:downloader) { downloader_class.new(collection) }

  describe "#initialize" do
    it "receives a collection" do
      expect(downloader.collection).to eq(collection)
    end
  end

  describe ".instance" do
    context "without .instance call" do
      it "sets instance to :object" do
        expect(downloader_class.instance_method).to eq(:object)
      end
    end

    it "sets the instance to the value passed" do
      downloader_class.instance :user
      expect(downloader_class.instance_method).to eq(:user)
    end
  end

  describe "#instance" do
    before do
      downloader_class.attribute(:email)

      downloader_class.instance :user
      downloader_class.send(:define_method, :email) do
        "#{user.id}@apple.com"
      end
    end

    it "should include the user instance method in the email method" do
      expect(downloader.records.first).to eq(["0@apple.com"])
    end
  end

  describe ".attribute" do
    it "pushes an attribute to a set of attributes" do
      downloader_class.attribute :first_name
      expect(downloader_class.attributes.size).to eq(1)
      expect(downloader_class.attributes.first.name).to eq(:first_name)
    end

    context "when using a header option" do
      it "pushes the attribute along with the header to the set of attributes" do
        downloader_class.attribute :first_name, header: "Primer nombre"
        expect(downloader_class.attributes.first.header).to eq("Primer nombre")
      end
    end
  end

  describe ".headers" do
    before do
      downloader_class.attribute(:id)
      downloader_class.attribute(:last_name)
    end

    it "returns the attributes names" do
      expect(downloader_class.headers).to eq(["Id", "Last Name"])
    end

    context "when using a custom header" do
      before do
        downloader_class.attribute(:username, header: "Usuario")
      end

      it "should assign the header to the attribute" do
        expect(downloader_class.headers).to eq(["Id", "Last Name", "Usuario"])
      end
    end
  end

  describe "#build_records" do
    before do
      downloader_class.attribute(:id)
      downloader_class.attribute(:name)
      downloader_class.attribute(:last_name)
    end

    it "should generate a collection of writable records" do
      expect(downloader.records.size).to eq(3)
      expect(downloader.records.last).to eq(["2", "User 2", "Last Name 2"])
    end
  end
end
