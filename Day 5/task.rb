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
  print "\nSelect an option: "
end

def validate_input(value, field_name)
  if value.strip.empty?
    puts "#{field_name} cannot be blank."
    return false
  end
  true
end

def display_book(book)
  puts "Title  : #{book[:title]}"
  puts "Author : #{book[:author]}"
  puts "Genre  : #{book[:genre]}"
  puts "Year   : #{book[:year]}"
  puts "-" * 30
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

  books.push({ title: title, author: author, genre: genre, year: year })
  puts "Book added!"
end

def list_books(books)
  puts "\n--- Listing First 3 Books ---\n"
  if books.empty?
    puts "No books available."
  else
    books.first(3).each do |book|
      display_book(book)
    end
  end
end

def list_all_books(books)
  puts "\n--- Listing All Books ---\n"
  if books.empty?
    puts "No books available."
  else
    books.each do |book|
      display_book(book)
    end
  end
end

def search_book(books)
  puts "\n--- Searching for a Book ---"
  print "Enter book title: "
  target_title = gets.chomp

  book = books.find { |b| b[:title].downcase.include?(target_title.downcase) }

  if book
    puts "\nFound Book:"
    display_book(book)
  else
    puts "Book not found."
  end
end

def delete_book(books)
  puts "\n--- Deleting a Book ---"
  print "Enter book title to delete: "
  target_title = gets.chomp

  if books.reject! { |b|
