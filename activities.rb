# frozen_string_literal: true

require_relative 'shared'
require 'temporalio/activity'

module MoneyTransfer
  module BankActivities
    # Activity that withdraws a specified amount from the source account,
    # raising an InsufficientFundsError if the amount is too large.
    # It returns the transaction ID for the withdrawal.
    class Withdraw < Temporalio::Activity::Definition
      def execute(details)
        puts("Doing a withdrawal from #{details.source_account} for #{details.amount}")
        raise InsufficientFundsError, 'Transfer amount too large' if details.amount > 1000

        # Generate and returnt the transaction ID
        "OKW-#{details.amount}-#{details.source_account}"
      end
    end
  end
end

