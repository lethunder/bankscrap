module Bankscrap
  class Account
    include Utils::Inspectable

    attr_accessor :bank, :id, :name, :balance,
                  :available_balance, :description,
                  :transactions, :iban, :bic,
                  :raw_data

    def initialize(params = {})
      raise NotMoneyObjectError, :balance unless params[:balance].is_a?(Money)
      raise NotMoneyObjectError, :available_balance unless params[:available_balance].is_a?(Money)

      params.each { |key, value| send "#{key}=", value }
    end

    def transactions
      @transactions ||= bank.fetch_transactions_for(self)
    end

    def fetch_transactions(start_date: Date.today - 2.years, end_date: Date.today)
      bank.fetch_transactions_for(self, start_date: start_date, end_date: end_date)
    end

    def currency
      balance.try(:currency)
    end

    def to_s
      description
    end

    def to_a
      [id, iban, name, description, balance]
    end

    private

    def inspect_attributes
      %i[id name balance available_balance description iban bic]
    end
  end
end
