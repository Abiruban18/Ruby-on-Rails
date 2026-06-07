books = []

# --- Helper Methods for Menu & Actions ---

def show_menu
  puts "\n=== Library Management System ==="
  puts "1. Add a book"
  puts "2. List first 3 books"
  puts "3. Search book"
  puts "4. Delete book"
  puts "5. Update book"
  puts "6. Exit"
  puts "7. List all books"
  puts "8. Browse book by genre"
  puts "9. Library summary" # Added Option 9
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

# --- Exercise Solution Method ---
def book_summary(books)
  puts "\n--- Library Summary ---"
  
  # Edge Case: Handle empty library
  if books.empty?
    puts "Library is empty."
    return
  end

  # 1. Total books count
  total_books = books.length

  # 2. Most recently added book (the last item in the array)
  most_recent_book = books.last[:title]

  # 3. Oldest book by year (find the minimum value based on the :year key)
  oldest_book = books.min_by { |book| book[:year] }

  # Print the one-line report
  puts "Total books: #{total_books} | Most Recent: '#{most_recent_book}' | Oldest: '#{oldest_book[:title]}' (#{oldest_book[:year]})"
end

# (Other existing action methods like list_books, delete_book, etc. remain here)

# --- Main Program Loop ---

loop do
  show_menu
  choice = gets.chomp

  case choice
  when "1" then add_book(books)
  when "2" then list_books(books) # implementation from previous step
  when "3" then search_book(books)
  when "4" then delete_book(books)
  when "5" then update_book(books)
  when "6" then puts "Goodbye!"; break
  when "7" then list_all_books(books)
  when "8" then browse_by_genre(books)
  when "9" then book_summary(books) # Hooked up option 9
  else
    puts "Invalid option. Please try again."
  end
end
