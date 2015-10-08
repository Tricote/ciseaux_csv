require 'test_helper'

class CsovFileTest < Minitest::Test
  def test_csov_file_to_array
    filepath = File.expand_path("csov_files/posts.csv", File.dirname(__FILE__))
    csov_file= CiseauxCsv::CsovFile.new(filepath)
    
    results = csov_file.to_a

    assert_kind_of Array, results
    assert_equal 3, results.size
    assert_kind_of Hash, results[0]
  end

  def test_csov_file_map
    filepath = File.expand_path("csov_files/posts.csv", File.dirname(__FILE__))
    csov_file= CiseauxCsv::CsovFile.new(filepath)
    
    results = csov_file.map { |csov_hash| csov_hash["title"] }
    
    assert_kind_of Array, results
    assert_equal 3, results.size
    assert_kind_of String, results[0]
    assert_equal "Second Post !", results[1] 
  end
end
