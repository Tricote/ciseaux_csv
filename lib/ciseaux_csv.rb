require "ciseaux_csv/version"
require "ciseaux_csv/attribute_parser"
require "ciseaux_csv/csov_file"

module CiseauxCsv
  DEFAULT_OPTIONS = {
    col_sep: ";",
    quote_char: '"',
    file_encoding: 'utf-8',
    nested_separator: "|"
  }
end
