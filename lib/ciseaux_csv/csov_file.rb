require 'csv'

module CiseauxCsv

  # Class to read and parse CSOV CSV files
  # implement Enumerable to iterate over the hash objects
  # built from the CSOV file
  #
  # @example
  #   filepath = File.expand_path("csov_files/posts.csv", File.dirname(__FILE__))
  #   csov_file = CiseauxCsv::CsovFile.new(filepath)
  #   csov_file.to_a
  #   #=> [
  #         {"title" => "First Post", ...},
  #         {"title" => "Second Post", ...},
  #         {"title" => "Third Post", ...}
  #       ]
  class CsovFile
    include Enumerable
    attr_reader :input, :options, :csv_options

    # @param csov_file [String, File] path to the csov csv file or File object
    # @param options [Hash] options
    # @option options [String] :col_sep (';') csv column separator 
    # @option options [String] :quote_char ('"') csv quote character
    # @option options [String] :file_encoding ('utf-8') csv file encoding
    # @option options [String] :collection_separator ('|') csov collection separator
    def initialize(csov_file, options = {})
      @input = csov_file
      @options = DEFAULT_OPTIONS.merge(options)
      @csv_options = @options.select {|k, v| k == :col_sep || k == :quote_char }
    end

    # Iterates over each the object hash
    # built from the lines of the CSOV file
    # 
    # @yield [Hash] Gives each object Hash to the block
    def each(&block)
      io = input.respond_to?(:readline) ? input : File.new(input, "r:#{options[:file_encoding]}")
      csov_header = nil

      IO.foreach(io) do |line|
        line.chomp!
        if csov_header
          hash = {}
          CSV.parse(line, csv_options) do |row|
            row.each_with_index do |value, index|
               AttributeParser.new(options[:nested_separator]).assign(hash, csov_header[index], value)
            end
          end
          block.call(hash)
        else
          csov_header = CSV.parse_line(line, csv_options)
        end
      end
    end

  end
end