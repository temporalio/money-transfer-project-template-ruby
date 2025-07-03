# frozen_string_literal: true

require 'json/add/struct'
require 'temporalio/error'

module MoneyTransfer
  TASK_QUEUE_NAME = 'money-transfer'

  # NOTE: The two custom error types that follow are defined in an
  # unusual way, by subclassing ApplicationError and overriding its
  # non_retryable method. This is a workaround for an SDK bug (#294).
  # Typically, you would subclass StandardError and specify the type
  # as non-retryable in the RetryPolicy, but this approach does not
  # work due to the bug. We'll update the code once the bug is fixed.
  class InsufficientFundsError < Temporalio::Error::ApplicationError
    def non_retryable
      true
    end
  end

  # InvalidAccountError is raised when the account identifier
  # for the transaction does not reference an active account.
  class InvalidAccountError < Temporalio::Error::ApplicationError
    def non_retryable
      true
    end
  end

  # TransferDetails is the input to MoneyTransferWorkflow. It specifies
  # the source and target accounts, the amount of the transfer, and a
  # reference ID that uniquely identifies the transaction.
  TransferDetails = Struct.new(:source_account, :target_account, :amount, :reference_id) do
    def to_s
      "TransferDetails { #{source_account}, #{target_account}, #{amount}, #{reference_id} }"
    end
  end
end
