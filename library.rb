# Global storage for books
$books = []

def show_menu
  puts "\n*** LIBRARY MANAGEMENT SYSTEM ***"
  puts "1. Add a book"
  puts "2. List first 3 books"
  puts "3. Search book by title"
  puts "4. Delete book"
  puts "5. Update book"
  puts "6. Exit"
  puts "7. List all books"
  puts "8. Browse books by genre"
  print "\nSelect an option: "
end

def add_book(title, author, genre, year)
  $books << { title: title, author: author, genre: genre, year: year }
  puts "Book added successfully!"
end

def display_books(book_list, limit = nil)
  if book_list.empty?
    puts "No books found."
    return
  end

  # If a limit is provided, take only that many books
  list_to_show = limit ? book_list.first(limit) : book_list

  list_to_show.each_with_index do |book, index|
    puts "#{index + 1}. #{book[:title]} by #{book[:author]} [#{book[:genre]}] (#{book[:year]})"
  end
end

def delete_book(title)
  # reject! returns nil if no changes were made
  if $books.reject! { |book| book[:title].downcase == title.downcase }
    puts "Book '#{title}' successfully deleted."
  else
    puts "Book not found."
  end
end

def search_by_title(title)
  # Finds all books that contain the search term (case-insensitive)
  $books.select { |book| book[:title].downcase.include?(title.downcase) }
end

def search_by_genre(genre)
  $books.select { |book| book[:genre].downcase == genre.downcase }
end

def update_book(title)
  book = $books.find { |b| b[:title].downcase == title.downcase }
  
  if book
    puts "Book found! Leave blank to keep current value."
    
    print "New Title [#{book[:title]}]: "
    new_title = gets.chomp
    book[:title] = new_title unless new_title.empty?

    print "New Author [#{book[:author]}]: "
    new_author = gets.chomp
    book[:author] = new_author unless new_author.empty?

    print "New Genre [#{book[:genre]}]: "
    new_genre = gets.chomp
    book[:genre] = new_genre unless new_genre.empty?

    print "New Year [#{book[:year]}]: "
    new_year = gets.chomp
    book[:year] = new_year.to_i unless new_year.empty?

    puts "Book updated successfully!"
  else
    puts "Book not found."
  end
end

# --- Main Program Loop ---
loop do
  show_menu
  option = gets.chomp.to_i
  puts "\n"

  case option
  when 1
    puts "--- Adding a New Book ---"
    print "Title: "
    title = gets.chomp
    print "Author: "
    author = gets.chomp
    print "Genre: "
    genre = gets.chomp
    print "Year: "
    year = gets.chomp.to_i

    add_book(title, author, genre, year)

  when 2
    puts "--- Listing First 3 Books ---"
    display_books($books, 3)

  when 3
    puts "--- Searching for a Book ---"
    print "Enter book title (or part of it): "
    title = gets.chomp
    results = search_by_title(title)
    display_books(results)

  when 4
    puts "--- Deleting a Book ---"
    print "Enter book title to delete: "
    title = gets.chomp
    delete_book(title)

  when 5
    puts "--- Updating a Book ---"
    print "Enter book title to update: "
    title = gets.chomp
    update_book(title)

  when 6
    puts "Exiting... Goodbye!"
    break

  when 7
    puts "--- Listing All Books ---"
    display_books($books)

  when 8
    puts "--- Browsing by Genre ---"
    print "Enter genre: "
    genre = gets.chomp
    results = search_by_genre(genre)
    display_books(results)

  else
    puts "Invalid option. Please try again."
  end
end
