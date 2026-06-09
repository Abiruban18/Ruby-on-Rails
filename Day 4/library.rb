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
  print "\nSelect an option: "
end

def add_book(books)
  puts "\n--- Adding a New Book ---"
  print "Title: "
  title = gets.chomp
  print "Author: "
  author = gets.chomp
  print "Genre: "
  genre = gets.chomp
  print "Year: "
  year = gets.chomp.to_i

  books.push({ title: title, author: author, genre: genre, year: year })
  puts "Book added!"
end

def list_books(books)
  puts "\n--- Listing First 3 Books ---"
  if books.empty?
    puts "No books available."
  else
    books.first(3).each_with_index do |book, i|
      puts "#{i + 1}. #{book[:title]} — #{book[:author]} (#{book[:year]})"
    end
  end
end

def list_all_books(books)
  puts "\n--- Listing All Books ---"
  if books.empty?
    puts "No books available."
  else
    books.each_with_index do |book, i|
      puts "#{i + 1}. #{book[:title]} — #{book[:author]} (#{book[:year]})"
    end
  end
end

def search_book(books)
  puts "\n--- Searching for a Book ---"
  print "Enter book title: "
  target_title = gets.chomp

  book = books.find { |b| b[:title].downcase == target_title.downcase }

  if book
    puts "Found: #{book[:title]} by #{book[:author]} (#{book[:year]})"
  else
    puts "Book not found."
  end
end

def delete_book(books)
  puts "\n--- Deleting a Book ---"
  print "Enter book title to delete: "
  target_title = gets.chomp

  if books.reject! { |b| b[:title].downcase == target_title.downcase }
    puts "Book successfully deleted."
  else
    puts "Book not found."
  end
end

def update_book(books)
  puts "\n--- Updating a Book ---"
  print "Enter book title to update: "
  target_title = gets.chomp
  
  book = books.find { |b| b[:title].downcase == target_title.downcase }

  if book
    print "Enter new title (or press enter to skip): "
    new_title = gets.chomp
    book[:title] = new_title unless new_title.empty?
    puts "Book updated!"
  else
    puts "Book not found."
  end
end

def show_dev_stats(books)
  puts "\n--- Developer Stats ---"
  if books.empty?
    puts "Library is empty. No stats available."
    return
  end

  total = books.count
  recent_books = books.count { |b| b[:year] > 2000 }
  authors = books.map { |b| b[:author] }.uniq

  puts "Total Books: #{total}"
  puts "Books published after 2000: #{recent_books}"
  puts "Unique Authors: #{authors.join(', ')}"
end

loop do
  show_menu
  choice = gets.chomp

  case choice
  when "1" then add_book(books)
  when "2" then list_books(books)
  when "3" then search_book(books)
  when "4" then delete_book(books)
  when "5" then update_book(books)
  when "6" then puts "Goodbye!"; break
  when "7" then list_all_books(books)
  when "8" then show_dev_stats(books)
  else
    puts "Invalid option. Please try again."
  end
end
