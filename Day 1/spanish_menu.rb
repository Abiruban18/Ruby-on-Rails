def show_spanish_menu
  puts "\n=== Sistema de Gestión de Biblioteca ==="
  puts "1. Agregar un libro"
  puts "2. Listar libros"
  puts "3. Buscar un libro"
  puts "4. Actualizar un libro"
  puts "5. Eliminar un libro"
  puts "6. Salir"
  puts "----------------------------------------"
  
  print "Presione Enter para regresar al menú principal..."
  gets
end

loop do
  puts "\n=== Library Management System ==="
  puts "1. Add a book"
  puts "2. List books"
  puts "3. Search for a book"
  puts "4. Update a book"
  puts "5. Delete a book"
  puts "6. Exit"
  
  print "Enter your choice: "
  choice = gets.chomp

  case choice
  when "0"
    show_spanish_menu 
  when "1"
    puts "→ Add book - coming soon!"
  when "2"
    puts "→ List books - coming soon!"
  when "3"
    puts "→ Search for a book - coming soon!"
  when "4"
    puts "→ Update a book - coming soon!"
  when "5"
    puts "→ Delete a book - coming soon!"
  when "6"
    puts "Good bye"
    break 
  else
    puts "Invalid option. Please try again."
  end
end
=begin  
=== Library Management System ===
1. Add a book
2. List books
3. Search for a book
4. Update a book
5. Delete a book
6. Exit
Enter your choice: 0

=== Sistema de Gestión de Biblioteca ===
1. Agregar un libro
2. Listar libros
3. Buscar un libro
4. Actualizar un libro
5. Eliminar un libro
6. Salir
----------------------------------------
Presione Enter para regresar al menú principal...1

=== Library Management System ===
1. Add a book
2. List books
3. Search for a book
4. Update a book
5. Delete a book
6. Exit
Enter your choice: 2
→ List books - coming soon!

=== Library Management System ===
1. Add a book
2. List books
3. Search for a book
4. Update a book
5. Delete a book
6. Exit
Enter your choice: 3
→ Search for a book - coming soon!

=== Library Management System ===
1. Add a book
2. List books
3. Search for a book
4. Update a book
5. Delete a book
6. Exit
Enter your choice: 4
→ Update a book - coming soon!

=== Library Management System ===
1. Add a book
2. List books
3. Search for a book
4. Update a book
5. Delete a book
6. Exit
Enter your choice: 5
→ Delete a book - coming soon!

=== Library Management System ===
1. Add a book
2. List books
3. Search for a book
4. Update a book
5. Delete a book
6. Exit
Enter your choice: 6
Good bye
=end
