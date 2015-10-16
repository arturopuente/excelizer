module Excelizer
  class Attribute

    attr_reader :name

    def initialize(name, options)
      self.name = name
      self.header = options[:header] unless options[:header].nil?
    end

    def header
      (@header || default_header)
    end

    private

    attr_writer :name, :header

    def default_header
      name.to_s.split("_").map(&:capitalize).join(" ")
    end
  end
end
