require 'test_helper'

class AttributeParserTest < Minitest::Test

  def test_assign_nil
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "title", nil)
    assert_nil h["title"]
  end

  def test_assign_simple
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "title", "Post 1")
    assert_equal "Post 1", h["title"]
  end

  def test_assign_nested
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "author[name]", "Bill")
    assert_equal "Bill", h["author"]["name"]
  end

  def test_assign_deep_nested
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "author[company][country]", "France")
    assert_equal "France", h["author"]["company"]["country"]
  end

  def test_assign_array
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "permissions[]", "read|write")
    assert_equal ["read", "write"], h["permissions"]
  end

  def test_assign_collection_of_simple_objects
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "comments[][date]", "2015-01-01|2015-01-02")
    
    assert_kind_of Array, h["comments"]
    assert_equal "2015-01-01", h["comments"][0]["date"]
    assert_equal "2015-01-02", h["comments"][1]["date"]
  end

  def test_assign_collection_of_objects
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "company[comments][][date]", "2015-01-01|2015-01-02")
    CiseauxCsv::AttributeParser.new.assign(h, "company[comments][][author]", "first author|second author")

    assert_kind_of Array, h["company"]["comments"]

    assert_equal "2015-01-01", h["company"]["comments"][0]["date"]
    assert_equal "2015-01-02", h["company"]["comments"][1]["date"]

    assert_equal "first author", h["company"]["comments"][0]["author"]
    assert_equal "second author", h["company"]["comments"][1]["author"]
  end

  def test_assign_collection_of_objects_with_nested
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "comments[][author][first_name]", "Thibaut|Morgane")
    CiseauxCsv::AttributeParser.new.assign(h, "comments[][author][last_name]", "Decaudain|Goualin")
    
    assert_kind_of Array, h["comments"]
    assert_equal "Thibaut", h["comments"][0]["author"]["first_name"]
    assert_equal "Decaudain", h["comments"][0]["author"]["last_name"]
    assert_equal "Morgane", h["comments"][1]["author"]["first_name"]
    assert_equal "Goualin", h["comments"][1]["author"]["last_name"]
  end

  def test_assign_full
    h = {}
    CiseauxCsv::AttributeParser.new.assign(h, "title", "Post 1")
    CiseauxCsv::AttributeParser.new.assign(h, "author[name]", "Bill")
    CiseauxCsv::AttributeParser.new.assign(h, "permissions[]", "read|write")
    CiseauxCsv::AttributeParser.new.assign(h, "comments[][date]", "2015-01-01|2015-01-02")
    CiseauxCsv::AttributeParser.new.assign(h, "comments[][author][first_name]", "Thibaut|Morgane")
    CiseauxCsv::AttributeParser.new.assign(h, "comments[][author][last_name]", "Decaudain|Goualin")

    assert_equal "Post 1", h["title"]
    assert_equal "Bill", h["author"]["name"]

    assert_kind_of Array, h["permissions"]
    assert_equal ["read", "write"], h["permissions"]
    
    assert_kind_of Array, h["comments"]
    assert_equal "2015-01-01", h["comments"][0]["date"]
    assert_equal "2015-01-02", h["comments"][1]["date"]
    
    assert_equal "Thibaut", h["comments"][0]["author"]["first_name"]
    assert_equal "Decaudain", h["comments"][0]["author"]["last_name"]
    assert_equal "Morgane", h["comments"][1]["author"]["first_name"]
    assert_equal "Goualin", h["comments"][1]["author"]["last_name"]
  end
end