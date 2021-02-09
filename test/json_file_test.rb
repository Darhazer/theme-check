# frozen_string_literal: true
require "test_helper"

class JsonFileTest < Minitest::Test
  def setup
    @json_files = [
      make_json_file("locales/en.json", "{}"),
      make_in_memory_json_file("locales/en.json", "{}"),
    ]
  end

  def test_name
    @json_files.each do |json|
      assert_equal("locales/en", json.name)
    end
  end

  def test_relative_path
    @json_files.each do |json|
      assert_equal("locales/en.json", json.relative_path.to_s)
    end
  end

  def test_content
    @json_files.each do |json|
      assert_equal({}, json.content)
    end
  end

  def test_content_with_error
    @json_files = make_json_files("locales/en.json", "{")
    @json_files.each do |json|
      assert_nil(json.content)
    end
  end

  def test_parse_error
    @json_files.each do |json|
      assert_nil(json.parse_error)
    end
  end

  def test_parse_error_with_error
    @json_files = make_json_files("locales/en.json", "{")
    @json_files.each do |json|
      assert_instance_of(JSON::ParserError, json.parse_error)
    end
  end

  private

  def make_json_file(name, content)
    theme = make_theme(name => content)
    ThemeCheck::JsonFile.new(theme.root.join(name), theme.root)
  end

  def make_in_memory_json_file(name, content)
    ThemeCheck::InMemoryJsonFile.new(name, content)
  end

  def make_json_files(name, content)
    [
      make_json_file(name, content),
      make_in_memory_json_file(name, content),
    ]
  end
end
