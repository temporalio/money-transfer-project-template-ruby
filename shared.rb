# frozen_string_literal: true

require 'json/add/struct'

module MoneyTransfer
  TASK_QUEUE_NAME = 'money-transfer'

  # TransferDetails is the input to MoneyTransferWorkflow. It specifies
  # the source and target accounts, the amount of the transfer, and a
  # reference ID that uniquely identifies the transaction.
  TransferDetails = Struct.new(:source_account, :target_account, :amount, :reference_id) do
    def to_s
      "TransferDetails { #{source_account}, #{target_account}, #{amount}, #{reference_id} }"
    end
  end
end
