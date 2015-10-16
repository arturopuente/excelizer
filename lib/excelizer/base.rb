module Excelizer
  class Base

    attr_reader :collection

    def initialize(collection = [])
      self.collection = collection
    end

    def download
      Excelizer::Writer.write self.class.headers, records
    end

    def records
      collection.map do |item|
        @record = item
        self.class.attributes.map do |attribute|
          if item.respond_to?(attribute.name)
            item.send(attribute.name)
          else
            self.send(attribute.name)
          end.to_s
        end
      end
    end

    private

    attr_writer :collection

    class << self
      def instance(instance_method)
        self.instance_method = instance_method
        define_method(instance_method) { @record }
      end

      def instance_method
        @instance_method ||= :object
      end

      def attribute(name, options = {})
        attributes << Attribute.new(name, options)
      end

      def attributes
        @attributes ||= []
      end

      def headers
        attributes.flat_map(&:header)
      end

      private

      attr_writer :instance_method
    end
  end
end
