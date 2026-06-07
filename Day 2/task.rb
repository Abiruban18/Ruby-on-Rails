books = []

def show_menu
  puts "\n*** LIBRARY MANAGEMENT SYSTEM ***"
  puts "1. Add a book"
  puts "2. List first 3 books"
  puts "3. Search book"
  puts "4. Delete book"
  puts "5. Update book"
  puts "6. Exit"
  puts "7. List all books"
  puts "8. Browse book by genre"
  print "\nSelect an option: "
end

loop do
  show_menu
  option = gets.chomp.to_i
  puts "\nYou selected option #{option}" unless option == 6

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

    # Pushing a hash into the array
    books.push({ title: title, author: author, genre: genre, year: year })
    puts "Book added successfully!"

  when 2
    puts "--- Listing First 3 Books ---"
    if books.empty?
      puts "No books available."
    else
      # Using .first(3).each as requested
      books.first(3).each.with_index(1) do |book, index|
        puts "#{index}. #{book[:title]} - #{book[:author]} [#{book[:genre]}] (#{book[:year]})"
      end
    end

  when 3
    puts "--- Searching for a Book ---"
    print "Enter title to search: "
    search_title = gets.chomp.downcase
    
    found_books = books.select { |b| b[:title].downcase.include?(search_title) }
    if found_books.empty?
      puts "No matching books found."
    else
      found_books.each { |b| puts "#{b[:title]} by #{b[:author]}" }
    end

  when 4
    puts "--- Deleting a Book ---"
    print "Enter book title to delete: "
    target_title = gets.chomp

    # Using .reject! to modify the original array
    # case-insensitive comparison ensures it works smoothly
    deleted = books.reject! { |book| book[:title].downcase == target_title.downcase }
    
    if deleted
      puts "Book successfully deleted."
    else
      puts "Book not found."
    end

  when 5
    puts "--- Updating a Book ---"
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

  when 6
    puts "Exiting..."
    break

  when 7
    puts "--- Listing All Books ---"
    if books.empty?
      puts "No books available."
    else
      # Iterating through all books using .each
      books.each.with_index(1) do |book, index|
        puts "#{index}. #{book[:title]} - #{book[:author]} [#{book[:genre]}] (#{book[:year]})"
      end
    end

  when 8
    puts "--- Browsing by Genre ---"
    print "Enter genre: "
    target_genre = gets.chomp.downcase
    
    matched = books.select { |b| b[:genre].downcase == target_genre }
    if matched.empty?
      puts "No books found in this genre."
    else
      matched.each { |b| puts "#{b[:title]} by #{b[:author]}" }
    end

  else
    puts "Invalid option. Please try again."
  end
end
