module Excelizer
  class Writer
    require "spreadsheet" unless defined?(Spreadsheet)

    def self.write(headers, records)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      sheet.row(0).push *headers
      records.each_with_index do |record, index|
        sheet.row(index + 1).push *record
      end

      self.persist book
    end

    def self.persist(book, file=StringIO.new)
      book.write file
      file.string
    end
  end
end
