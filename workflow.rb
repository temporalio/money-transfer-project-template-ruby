# frozen_string_literal: true

require_relative 'activities'
require_relative 'shared'
require 'temporalio/workflow'

module MoneyTransfer
  # Temporal Workflow that withdraws the specified amount from the source
  # account and deposits it into the target account.
  class MoneyTransferWorkflow < Temporalio::Workflow::Definition
    def execute(details)
      Temporalio::Workflow.logger.info("Starting workflow (#{details})")

      withdraw_result = Temporalio::Workflow.execute_activity(
        BankActivities::Withdraw,
        details,
        start_to_close_timeout: 5
      )
      Temporalio::Workflow.logger.info("Withdrawal confirmation: #{withdraw_result}")

      deposit_result = Temporalio::Workflow.execute_activity(
        BankActivities::Deposit,
        details,
        start_to_close_timeout: 5
      )
      Temporalio::Workflow.logger.info("Deposit confirmation: #{deposit_result}")

      "Transfer complete (transaction IDs: #{withdraw_result}, #{deposit_result})"
    end
  end
end
