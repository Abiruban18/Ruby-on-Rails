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


# --- Book Class ---

class Book
  include Displayable
  include Comparable

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

  # Defines sorting rules for Comparable (Oldest to Newest)
  def <=>(other)
    @year <=> other.year
  end
end


# --- Library Class ---

class Library
  include Searchable

  # Expose the internal array so methods like library.books.sort work directly
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
    end

    total = @books.count
    recent_books = @books.count { |b| b.year > 2000 }
    unique_authors = @books.map(&:author).uniq

    puts "Total Books: #{total}"
    puts "Books published after 2000: #{recent_books}"
    puts "Unique Authors: #{unique_authors.join(', ')}"
  end

  # Leveraging the fact that books are Comparable: we can just call .sort!
  def filter_between_years(start_year, end_year)
    filtered = @books.select { |b| b.year >= start_year && b.year <= end_year }

    if filtered.empty?
      puts "No books found in this year range."
      return
    end

    filtered.sort.each(&:display)
  end

  def summary
    if @books.empty?
      puts "Library is empty."
      return
    end

    total_books = @books.length
    most_recent_added = @books.last.title
    oldest_book = @books.min # Comparable automatically gives us .min based on year
    recent_count = @books.count(&:recent?)

    puts "Total Books: #{total_books} | Recent Books (Last 5 Years): #{recent_count}"
    puts "Most Recently Added: '#{most_recent_added}'"
    puts "Oldest Book in Library: '#{oldest_book.title}' (#{oldest_book.year})"
  end

  def stats
    if @books.empty?
      return { total: 0, by
