# frozen_string_literal: true

require 'json/add/struct'

module MoneyTransfer
  TASK_QUEUE_NAME = 'money-transfer'

  # InsufficientFundsError is raised when the source account
  # balance is too low to successfully complete the withdrawal.
  class InsufficientFundsError < StandardError; end

  # InvalidAccountError is raised when the account identifier
  # for the transaction does not reference an active account.
  class InvalidAccountError < StandardError; end

  # TransferDetails is the input to MoneyTransferWorkflow. It specifies
  # the source and target accounts, the amount of the transfer, and a
  # reference ID that uniquely identifies the transaction.
  TransferDetails = Struct.new(:source_account, :target_account, :amount, :reference_id) do
    def to_s
      "TransferDetails { #{source_account}, #{target_account}, #{amount}, #{reference_id} }"
    end
  end
end
