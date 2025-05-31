module Logger
  def self.log_info(user, value)
    log="#{Time.now} -- info -- User #{user.name} transaction with value #{value} succeeded.\n"
    append_log_file(log)
  end

  def self.log_warning(user, value)
    log="#{Time.now} -- warnging -- User #{user.name} has #{value} balance.\n"
    append_log_file(log)
  end

  def self.log_error(user, value, message)
    log="#{Time.now} -- error -- User #{user.name} transaction with value #{value} failed with message #{message}.\n"
    append_log_file(log)
  end

  def self.append_log_file(log)
    path = './day2/'
    File.open("#{path}apps.log", 'a') {
      |f| f.write(log)
    }
  end
end

class User
  attr_accessor :name, :balance
  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  include Logger

  attr_reader :user, :amount
  def initialize(user, amount)
    @user = user
    @amount = amount
  end
end

class Bank
  attr_accessor :users
  def initialize(users)
    if self.class == Bank
      raise "Cannot instantiate Bank directly"
    else
      @users = users
    end
  end

  def process_transactions(transactions, &block)
    raise "This method should be overridden in subclasses"
  end
end

class CBABank < Bank
  include Logger

  def initialize(users)
    super(users)
  end

  def process_transactions(transactions, &block)
    log_start = transactions.map { |t| "user #{t.user.name} transaction with value #{t.amount}" }.join(', ')
    Logger.append_log_file("#{Time.now} -- info -- processing transaction for: #{log_start}\n")

    transactions.each do |transaction|
      begin
        if @users.include?(transaction.user)
          if transaction.user.balance + transaction.amount < 0
            raise "Not enough balance"
          end

          transaction.user.balance += transaction.amount

          if transaction.user.balance == 0
            Logger.log_warning(transaction.user, transaction.user.balance)
          end

          Logger.log_info(transaction.user, transaction.amount)
          puts "Call endpoint for success of User #{transaction.user.name} transaction with value #{transaction.amount}"
          block.call('success') if block_given?

        else
          raise "#{transaction.user.name} not exist in the bank"
        end

      rescue => e
        Logger.log_error(transaction.user, transaction.amount, e.message)
        puts "Call endpoint for failure of User #{transaction.user.name} transaction with value #{transaction.amount} with reason #{e.message}"
        block.call('failure') if block_given?
      end
    end
  end
end

users = [
  # User.new("Ali", 200),
  # User.new("Peter", 500),
  # User.new("Manda", 100),
  User.new("Ali", 100),
  User.new("John", 50),
  User.new("Ali", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -100),
  Transaction.new(users[2], -300),
  Transaction.new(users[1], -20),
  # Transaction.new(users[0], -100),
  # Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

bank = CBABank.new(users)
bank.process_transactions(transactions) do |status|
  puts status == 'success' ? "transaction processed successfully" : "transaction failed"
end