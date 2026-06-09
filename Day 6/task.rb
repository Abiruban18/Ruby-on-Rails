class Book
  attr_accessor :title, :author, :genre, :year

  def initialize(title, author, genre, year)
    @title = title
    @author = author
    @genre = genre
    @year = year
  end

  # Returns how many years old the book is based on the current year (2026)
  def age
    2026 - @year
  end

  # Returns true if the book was published in the last 5 years (2021 - 2026)
  def recent?
    self.age <= 5
  end

  def display
    puts "Title  : #{@title}"
    puts "Author : #{@author}"
    puts "Genre  : #{@genre}"
    puts "Year   : #{@year} (Age: #{self.age} #{self.age == 1 ? 'year' : 'years'})"
    puts "-" * 30
  end

  def to_s
    "#{@title} by #{@author} (#{@year})"
  end
end

books = []

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
  puts "9. Books between years"
  puts "10. Library summary"
  print "\nSelect an option: "
end

def validate_input(value, field_name)
  if value.strip.empty?
    puts "#{field_name} cannot be blank."
    return false
  end
  true
end

def add_book(books)
  puts "\n--- Adding a New Book ---"
  
  print "Title: "
  title = gets.chomp
  return unless validate_input(title, "Title")

  print "Author: "
  author = gets.chomp
  return unless validate_input(author, "Author")

  print "Genre: "
  genre = gets.chomp
  return unless validate_input(genre, "Genre")

  print "Year: "
  year_input = gets.chomp
  return unless validate_input(year_input, "Year")
  year = year_input.to_i

  books.push(Book.new(title, author, genre, year))
  puts "Book added!"
end

def list_books(books)
  puts "\n--- Listing First 3 Books ---\n"
  if books.empty?
    puts "No books available."
  else
    books.first(3).each do |book|
      book.display
    end
  end
end

def list_all_books(books)
  puts "\n--- Listing All Books ---\n"
  if books.empty?
    puts "No books available."
  else
    books.each do |book|
      book.display
    end
  end
end

def search_book(books)
  puts "\n--- Searching for a Book ---"
  print "Enter book title: "
  target_title = gets.chomp

  book = books.find { |b| b.title.downcase.include?(target_title.downcase) }

  if book
    puts "\nFound Book:"
    book.display
  else
    puts "Book not found."
  end
end

def delete_book(books)
  puts "\n--- Deleting a Book ---"
  print "Enter book title to delete: "
  target_title = gets.chomp

  if books.reject! { |b| b.title.downcase == target_title.downcase }
    puts "Book successfully deleted."
  else
    puts "Book not found."
  end
end

def update_book(books)
  puts "\n--- Updating a Book Title ---"
  print "Enter current book title: "
  target_title = gets.chomp
  
  book = books.find { |b| b.title.downcase == target_title.downcase }

  if book
    print "Enter new title: "
    new_title = gets.chomp
    
    return unless validate_input(new_title, "Title")
    cleaned_title = new_title.strip

    print "Rename '#{book.title}' → '#{cleaned_title}'? (y/n): "
    confirmation = gets.chomp.downcase

    if confirmation == 'y'
      book.title = cleaned_title
      puts "Book title updated successfully!"
    else
      puts "Update cancelled."
    end
  else
    puts "No book found with that title."
  end
end

def show_dev_stats(books)
  puts "\n--- Developer Stats ---"
  if books.empty?
    puts "Library is empty. No stats available."
    return
  end

  total = books.count
  recent_books = books.count { |b| b.year > 2000 }
  authors = books.map { |b| b.author }.uniq

  puts "Total Books: #{total}"
  puts "Books published after 2000: #{recent_books}"
  puts "Unique Authors: #{authors.join(', ')}"
end

def books_between_years(books)
  puts "\n--- Books Between Years ---"
  print "Enter start year: "
  start_input = gets.chomp
  return unless validate_input(start_input, "Start year")
  
  print "Enter end year: "
  end_input = gets.chomp
  return unless validate_input(end_input, "End year")

  start_year = start_input.to_i
  end_year = end_input.to_i

  if end_year < start_year
    puts "Invalid range."
    return
  end

  filtered_books = books.select { |b| b.year >= start_year && b.year <= end_year }

  if filtered_books.empty?
    puts "No books found in this year range."
    return
  end

  sorted_books = filtered_books.sort_by { |b| b.year }

  puts "\nBooks found:"
  sorted_books.each do |book|
    book.display
  end
end

def library_summary(books)
  puts "\n--- Library Summary ---"
  if books.empty?
    puts "Library is empty."
    return
  end

  total_books = books.length
  most_recent_added = books.last.title
  oldest_book = books.min_by { |b| b.year }
  
  # Uses the .recent? method to calculate the tally
  recent_count = books.count { |b| b.recent? }

  puts "Total Books: #{total_books} | Recent Books (Last 5 Years): #{recent_count}"
  puts "Most Recently Added: '#{most_recent_added}'"
  puts "Oldest Book in Library: '#{oldest_book.title}' (#{oldest_book.year})"
end

loop do
  show_menu
  choice = gets.chomp

  case choice
  when "1"  then add_book(books)
  when "2"  then list_books(books)
  when "3"  then search_book(books)
  when "4"  then delete_book(books)
  when "5"  then update_book(books)
  when "6"  then puts "Goodbye!"; break
  when "7"  then list_all_books(books)
  when "8"  then show_dev_stats(books)
  when "9"  then books_between_years(books)
  when "10" then library_summary(books)
  else
    puts "Invalid option. Please try again."
  end
end
