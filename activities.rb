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

    # Activity that deposits a specified amount into the target account,
    # raising an InvalidAccountError if that is not a valid account.
    # It returns the transaction ID for the deposit.
    class Deposit < Temporalio::Activity::Definition
      def execute(details)
        puts("Doing a deposit into #{details.target_account} for #{details.amount}")
        raise InvalidAccountError, 'Invalid account number' if details.target_account == 'B5555'

        # Generate and returnt the transaction ID
        "OKD-#{details.amount}-#{details.target_account}"
      end
    end

    # Activity that deposits a specified amount into the source account,
    # intended for cases in which a previous deposit attempt failed. This
    # is defined as a separate Activity, distinct from the Deposit, so
    # that it can perform any special handling that might be needed to
    # process the refund (such as making a call to a third-party system).
    # In this implementation, however, the behavior is identical to the
    # deposit (with the exception of the transaction ID and log message).
    # It returns the transaction ID for the refund.
    class Refund < Temporalio::Activity::Definition
      def execute(details)
        puts("Refunding #{details.amount} back to account #{details.source_account}")

        # Generate and returnt the transaction ID
        "OKR-#{details.amount}-#{details.source_account}"
      end
    end
  end
end
