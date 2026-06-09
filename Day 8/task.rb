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
    end

    total = @books.count
    recent_books = @books.count { |b| b.year > 2000 }
    unique_authors = @books.map(&:author).uniq

    puts "Total Books: #{total}"
    puts "Books published after 2000: #{recent_books}"
    puts "Unique Authors: #{unique_authors.join(', ')}"
  end

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
  puts "1. Add a book"
  puts "2. List first 3 books"
  puts "3. Search book"
  puts "4. Delete book"
  puts "5. Update book"
  puts "6. Exit"
  puts "7. List all books"
  puts "8. Developer stats"
  puts "9. Detailed Library Stats"
  puts "10. Export book to clipboard format" # Cleaned up option indexing mapping
  puts "11. Library summary"
  puts "12. Print Books Sorted by Year"
  print "\nSelect an option: "
end

def validate_input(value, field_name)
  if value.strip.empty?
    puts "#{field_name} cannot be blank."
    return false
  end
  true
end


# --- Execution Routine ---

library = Library.new

loop do
  show_menu
  choice = gets.chomp

  case choice
  when "1"
    puts "\n--- Adding a New Book ---"
    print "Title: "
    title = gets.chomp
    next unless validate_input(title, "Title")

    print "Author: "
    author = gets.chomp
    next unless validate_input(author, "Author")

    print "Genre: "
    genre = gets.chomp
    next unless validate_input(genre, "Genre")

    print "Year: "
    year_input = gets.chomp
    next unless validate_input(year_input, "Year")
    
    library.add(title, author, genre, year_input.to_i)

  when "2"
    puts "\n--- Listing First 3 Books ---\n"
    library.list(limit: 3)

  when "3"
    puts "\n--- Searching for a Book ---"
    print "Enter book title: "
    query = gets.chomp
    book = library.find_by_title(query)
    book ? book.display : puts("Book not found.")

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
      new_title = gets.chomp
      next unless validate_input(new_title, "Title")
      cleaned_title = new_title.strip

      print "Rename '#{book.title}' → '#{cleaned_title}'? (y/n): "
      if gets.chomp.downcase == 'y'
        library.update_title(current_title, cleaned_title)
      else
        puts "Update cancelled."
      end
    else
      puts "No book found with that title."
    end

  when "6"
    puts "Goodbye!"
    break

  when "7"
    puts "\n--- Listing All Books ---\n"
    library.list

  when "8"
    puts "\n--- Developer Stats ---"
    library.show_stats

  when "9"
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

  when "10"
    puts "\n--- Export Book to Clipboard Format ---"
    print "Enter book title to export: "
    query = gets.chomp
    book = library.find_by_title(query)
    
    if book
      puts "\nCopy the line below:"
      puts book.to_csv_row
    else
      puts "Book not found."
    end

  when "11"
    library.summary

  when "12"
    puts "\n--- Sorting Test (Oldest to Newest) ---\n"
    if library.books.empty?
      puts "Library is empty."
    else
      sorted_books = library.books.sort
      sorted_books.each(&:display)
    end

  else
    puts "Invalid option. Please try again."
  end
end
