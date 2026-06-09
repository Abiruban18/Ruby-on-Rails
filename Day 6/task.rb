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
  
  book = books.find { |b| b.title.downcase ==
