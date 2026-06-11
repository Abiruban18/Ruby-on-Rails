# --- Custom Exceptions ---

class BookNotFoundError < StandardError
  def initialize(title)
    super("Book not found: #{title}")
  end
end

class InvalidInputError < StandardError; end


# --- Mixin Modules ---

module Displayable
  def display
    puts "Title  : #{title}"
    puts "Author : #{author}"
    puts "Genre  : #{genre}"
    puts "Year   : #{year} (Age: #{age} #{age == 1 ? 'year' : 'years'})"
  end

  def to_s
    "#{title} by #{author} (#{year})"
  end
end

module Searchable
  def find_by_title(query)
    @books.find { |b| b.title.downcase.include?(query.downcase) }
  end

  def find_by_author(query)
    @books.select { |b| b.author.downcase.include?(query.downcase) }
  end
end

module Exportable
  def to_csv_row
    fields = [title, author, year.to_s, genre]
    processed_fields = fields.map { |f| f.include?(',') ? "\"#{f}\"" : f }
    processed_fields.join(',')
  end
end


# --- Base Book Class ---

class Book
  include Displayable
  include Comparable
  include Exportable

  attr_accessor :title, :author, :genre, :year

  def initialize(title, author, genre, year)
    @title = title
    @author = author
    @genre = genre
    @year = year
  end

  def age
    2026 - @year
  end

  def recent?
    age <= 5
  end

  def <=>(other)
    @year <=> other.year
  end
end


# --- Subclass: DigitalBook ---

class DigitalBook < Book
  attr_accessor :url

  def initialize(title, author, genre, year, url)
    super(title, author, genre, year)
    @url = url
  end

  def display
    super
    puts "URL    : #{@url}"
    puts "-" * 30
  end
end


# --- Exercise Solution: AudioBook Subclass ---

class AudioBook < Book
  attr_accessor :duration_minutes

  def initialize(title, author, genre, year, duration_minutes)
    super(title, author, genre, year)
    @duration_minutes = duration_minutes
  end

  def display
    super
    # Format minutes into hours and minutes
    hours = @duration_minutes / 60
    minutes = @duration_minutes % 60
    puts "Duration: #{hours}h #{minutes}m"
    puts "-" * 30
  end
end


# --- Library Class ---

class Library
  include Searchable
  attr_reader :books

  def initialize
    @books = []
  end

  def add_book_object(book_obj)
    @books.push(book_obj)
    puts "Book added!"
  end

  def list(limit: nil)
    if @books.empty?
      puts "No books available."
      return
    end

    collection = limit ? @books.first(limit) : @books
    collection.each do |book|
      book.display
      # Add trailing visual separator line if it is a base Book
      puts "-" * 30 if book.instance_of?(Book)
    end
  end

  def delete(title)
    before = @books.length
    @books.reject! { |b| b.title.downcase == title.downcase }
    raise BookNotFoundError.new(title) if @books.length == before
    puts "Book successfully deleted."
  end

  def update_title(current_title, new_title)
    book = find_by_title(current_title)
    raise BookNotFoundError.new(current_title) unless book

    book.title = new_title
    puts "Book title updated successfully!"
  end

  def show_stats
    if @books.empty?
      puts "Library is empty. No stats available."
      return
    end

    total = @books.count
    recent_books = @books.count { |b| b.year > 2000 }
    unique_authors = @books.map(&:author).uniq

    puts "Total Books: #{total}"
    puts "Books published after 2000: #{recent_books}"
    puts "Unique Authors: #{unique_authors.join(', ')}"
  end

  def summary
    if @books.empty?
      puts "Library is empty."
      return
    end

    total_books = @books.length
    most_recent_added = @books.last.title
    oldest_book = @books.min
    recent_count = @books.count(&:recent?)

    puts "Total Books: #{total_books} | Recent Books (Last 5 Years): #{recent_count}"
    puts "Most Recently Added: '#{most_recent_added}'"
    puts "Oldest Book in Library: '#{oldest_book.title}' (#{oldest_book.year})"
  end

  def stats
    if @books.empty?
      return { total: 0, by_genre: {}, average_year: 0 }
    end

    total_count = @books.length
    genre_counts = Hash.new(0)
    @books.each { |b| genre_counts[b.genre] += 1 }

    total_years = @books.map(&:year).sum
    avg_year = (total_years.to_f / total_count).round

    { total: total_count, by_genre: genre_counts, average_year: avg_year }
  end
end


# --- Interface Helpers & Input Validation ---

def show_menu
  puts "\n=== Library Management System ==="
  puts "1. Add a physical book"
  puts "2. List first 3 books"
  puts "3. Search book"
  puts "4. Delete book"
  puts "5. Update book"
  puts "6. Exit"
  puts "7. List all books"
  puts "8. Developer stats"
  puts "9. Add a digital book"
  puts "10. Add an audiobook" # Assigned to Option 10
  puts "11. Detailed Library Stats"
  puts "12. Export book to clipboard format"
  puts "13. Library summary"
  print "\nSelect an option: "
end

def validate_input!(value, field_name)
  if value.strip.empty?
    raise InvalidInputError, "#{field_name} cannot be blank."
  end
  value
end

def validate_year!(value)
  validate_input!(value, "Year")
  unless value.strip =~ /\A\d+\z/
    raise InvalidInputError, "Year must be a number."
  end
  value.to_i
end

# Validates duration format as a positive integer (> 0)
def validate_duration!(value)
  validate_input!(value, "Duration")
  unless value.strip =~ /\A\d+\z/ && value.to_i > 0
    raise InvalidInputError, "Duration must be a positive integer."
  end
  value.to_i
end


# --- Main Operational Runtime ---

library = Library.new

begin
  loop do
    show_menu
    choice = gets.chomp

    case choice
    when "1"
      puts "\n--- Adding a Physical Book ---"
      print "Title: "
      title = validate_input!(gets.chomp, "Title")
      print "Author: "
      author = validate_input!(gets.chomp, "Author")
      print "Genre: "
      genre = validate_input!(gets.chomp, "Genre")
      print "Year: "
      year = validate_year!(gets.chomp)
      
      library.add_book_object(Book.new(title, author, genre, year))

    when "2"
      puts "\n--- Listing First 3 Books ---\n"
      library.list(limit: 3)

    when "3"
      puts "\n--- Searching for a Book ---"
      print "Enter book title: "
      query = gets.chomp
      book = library.find_by_title(query)
      
      if book
        puts "\nFound Book:"
        book.display
        puts "-" * 30 if book.instance_of?(Book)
      else
        raise BookNotFoundError.new(query)
      end

    when "4"
      puts "\n--- Deleting a Book ---"
      print "Enter book title to delete: "
      title = gets.chomp
      library.delete(title)

    when "5"
      puts "\n--- Updating a Book Title ---"
      print "Enter current book title: "
      current_title = gets.chomp
      
      book = library.find_by_title(current_title)
      if book
        print "Enter new title: "
        new_title = validate_input!(gets.chomp, "Title").strip

        print "Rename '#{book.title}' → '#{new_title}'? (y/n): "
        if gets.chomp.downcase == 'y'
          library.update_title(current_title, new_title)
        else
          puts "Update cancelled."
        end
      else
        raise BookNotFoundError.new(current_title)
      end

    when "6"
      break

    when "7"
      puts "\n--- Listing All Books ---\n"
      library.list

    when "8"
      puts "\n--- Developer Stats ---"
      library.show_stats

    when "9"
      puts "\n--- Adding a Digital Book ---"
      print "Title: "
      title = validate_input!(gets.chomp, "Title")
      print "Author: "
      author = validate_input!(gets.chomp, "Author")
      print "Genre: "
      genre = validate_input!(gets.chomp, "Genre")
      print "Year: "
      year = validate_year!(gets.chomp)
      print "URL: "
      url = validate_input!(gets.chomp, "URL")

      library.add_book_object(DigitalBook.new(title, author, genre, year, url))

    when "10"
      puts "\n--- Adding an Audiobook ---"
      print "Title: "
      title = validate_input!(gets.chomp, "Title")
      print "Author: "
      author = validate_input!(gets.chomp, "Author")
      print "Genre: "
      genre = validate_input!(gets.chomp, "Genre")
      print "Year: "
      year = validate_year!(gets.chomp)
      print "Duration (in minutes): "
      duration = validate_duration!(gets.chomp)

      library.add_book_object(AudioBook.new(title, author, genre, year, duration))

    when "11"
      puts "\n--- Detailed Library Stats ---"
      data = library.stats
      puts "Total Books: #{data[:total]}"
      puts "Average Publication Year: #{data[:average_year]}"
      puts "Books by Genre:"
      if data[:by_genre].empty?
        puts "  No genres available."
      else
        data[:by_genre].each { |genre, count| puts "  - #{genre}: #{count}" }
      end

    when "12"
      puts "\n--- Export Book to Clipboard Format ---"
      print "Enter book title to export: "
      query = gets.chomp
      book = library.find_by_title(query)
      
      if book
        puts "\nCopy the line below:"
        puts book.to_csv_row
      else
        raise BookNotFoundError.new(query)
      end

    when "13"
      library.summary

    else
      puts "Invalid option. Please try again."
    end
  end

rescue BookNotFoundError => e
  puts "\n[Application Error] #{e.message}"
  retry
rescue InvalidInputError => e
  puts "\n[Validation Failure] #{e.message}"
  retry
rescue Interrupt
  puts "\nProcess interrupted."
ensure
  puts "\nSession ended. Goodbye!"
end
