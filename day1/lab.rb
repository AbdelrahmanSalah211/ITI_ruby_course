class Book
  attr_accessor :title, :author, :isbn, :count
  def initialize(title, author, isbn, count = 1)
    @title = title
    @author = author
    @isbn = isbn
    @count = count
  end
end

class Inventory
  attr_accessor :books

  def initialize(books = [])
    @books = books
    self.read_from_file('books.txt')
  end

  def add_book(book)
    existing_book = @books.find_index { |b| b.isbn == book.isbn }
    # puts existing_book
    if existing_book
      @books[existing_book].count += 1
      @books[existing_book].title = book.title
      @books[existing_book].author = book.author
      return
    end
    @books.push(book)
    # @books.uniq! { |book| book.isbn }
    @books.sort_by! { |book| book.isbn.to_i }
  end

  def remove_book(isbn)
    @books.delete_if { |book| book.isbn == isbn }
  end

  def search(search_by, search_value)
    results = @books.select { |book|
      case search_by
      when 'title'
        book.title.downcase.include?(search_value.downcase)
      when 'author'
        book.author.downcase.include?(search_value.downcase)
      when 'isbn'
        book.isbn.downcase.include?(search_value.downcase)
      else
        false
      end
    }
  end

  def list()
    @books.each { |book| puts "Title: #{book.title}, Author: #{book.author}, ISBN: #{book.isbn}, Count: #{book.count}" }
  end

  def save_to_file(filename)
    path = './'
    f = File.new(path + filename, 'w')
    @books.each {
      |book| f.write("#{book.title},#{book.author},#{book.isbn},#{book.count}\n")
    }
    f.close
  end

  private
  def read_from_file(filename)
    path = './'
    f = File.new(path + filename, 'r')
    f.each_line {
      |line|
      split_line = line.chomp.split(',')
      # puts split_line
      self.add_book(Book.new(split_line[0], split_line[1], split_line[2], split_line[3].to_i))
    }
    f.close
  end
end

inventory = Inventory.new()

while true
  puts "Enter a command (add, remove, search, list, exit):"
  command = gets.chomp.downcase

  case command
  when 'add'
    puts "Enter book title:"
    title = gets.chomp
    if title.empty?
      puts "Title cannot be empty."
      next
    end
    puts "Enter book author:"
    author = gets.chomp
    if author.empty?
      puts "Author cannot be empty."
      next
    end
    puts "Enter book ISBN:"
    isbn = gets.chomp
    if isbn.empty?
      puts "ISBN cannot be empty."
      next
    end
    inventory.add_book(Book.new(title, author, isbn))
  when 'remove'
    puts "Enter book ISBN to remove:"
    isbn = gets.chomp
    if isbn.empty?
      puts "ISBN cannot be empty."
      next
    end
    inventory.remove_book(isbn)
  when 'search'
    puts " Enter what to search by (title, author, isbn):"
    search_by = gets.chomp.downcase
    if !['title', 'author', 'isbn'].include?(search_by)
      puts "Invalid input."
      next
    end
    puts "Enter search value:"
    search_value = gets.chomp
    if search_value.empty?
      puts "Search value cannot be empty."
      next
    end
    result = inventory.search(search_by, search_value)
    unless result
      puts "No books found."
      next
    end
    puts "Search results:"
    result.each { |book| puts "Title: #{book.title}, Author: #{book.author}, ISBN: #{book.isbn}, Count: #{book.count}" }

  when 'list'
    inventory.list()
  when 'exit'
    inventory.save_to_file("books.txt")
    puts "Exiting the program."
    break
  else
    puts "Unknown command."
  end
end
