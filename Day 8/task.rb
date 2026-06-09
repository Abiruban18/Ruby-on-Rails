# --- Mixin Modules ---

module Displayable
  def display
    puts "Title  : #{title}"
    puts "Author : #{author}"
    puts "Genre  : #{genre}"
    puts "Year   : #{year} (Age: #{age} #{age == 1 ? 'year' : 'years'})"
    puts "-" * 30
  end

  def to_s
    "#{title} by #{author} (##{year})"
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

# --- Exercise Solution Module ---
module Exportable
  def to_csv_row
    fields = [title, author, year.to_s, genre]
    
    # Process each field: if it contains a comma, wrap it in double quotes
    processed_fields = fields.map do |field|
      field.include?(',') ? "\"#{field}\"" : field
    end

    processed_fields.join(',')
  end
end


# --- Book Class ---

class Book
  include Displayable
  include Comparable
  include Exportable # Added Exportable Mixin

  attr_accessor :title, :author, :genre, :year

  def initialize(title, author, genre, year)
    @title = title
    @author = author
    @genre = genre
    @year = year.to_i
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


# --- Library Class ---

class Library
  include Searchable
  attr_reader :books

  def initialize
    @books = []
  end

  def add(title, author, genre, year)
    @books.push(Book.new(title, author, genre, year))
    puts "Book added!"
  end

  def list(limit: nil)
    if @books.empty?
      puts "No books available."
      return
    end

    collection = limit ? @books.first(limit) : @books
    collection.each(&:display)
  end

  def delete(title)
    before = @books.length
    @books.reject! { |b| b.title.downcase == title.downcase }
    @books.length < before ? puts("Book successfully deleted.") : puts("Book not found.")
  end

  def update_title(current_title, new_title)
    book = find_by_title(current_title)
    if book
      book.title = new_title
      puts "Book title updated successfully!"
    else
      puts "No book found with that title."
    end
  end

  def show_stats
    if @books.empty?
      puts "Library is empty. No stats available."
      return
