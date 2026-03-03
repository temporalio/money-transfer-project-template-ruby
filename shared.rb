# frozen_string_literal: true

require 'json/add/struct'
require 'temporalio/env_config'
require 'temporalio/client'

module MoneyTransfer
  TASK_QUEUE_NAME = 'money-transfer'

  # InsufficientFundsError is raised when the source account
  # balance is too low to successfully complete the withdrawal.
  class InsufficientFundsError < StandardError; end

  # InvalidAccountError is raised when the account identifier
  # for the transaction does not reference an active account.
  class InvalidAccountError < StandardError; end

  # @@@SNIPSTART money-transfer-project-template-ruby-shared-transfer-details
  # TransferDetails is the input to MoneyTransferWorkflow (and its Activities).
  # It specifies the source (sender) and target (recipient) accounts, the amount
  # to transfer, and a reference ID that uniquely identifies the transaction.
  TransferDetails = Struct.new(:source_account, :target_account, :amount, :reference_id) do
    def to_s
      "TransferDetails { #{source_account}, #{target_account}, #{amount}, #{reference_id} }"
    end
  end
  # @@@SNIPEND

  # Create the Temporal Client that connects to the Temporal Service.
  # By default, it will connect to one running locally, on the standard
  # port, and use the default Namespace. You can override this by setting
  # the TEMPORAL_PROFILE environment variable to the name of a specific
  # profile that you've set up using the Temporal CLI.
  def self.create_client
    profile = ENV['TEMPORAL_PROFILE']
    args, kwargs = Temporalio::EnvConfig::ClientConfig.load_client_connect_options(
      profile: profile
    )

    args[0] ||= 'localhost:7233'
    args[1] ||= 'default'

    Temporalio::Client.connect(*args, **kwargs)
  end
end
