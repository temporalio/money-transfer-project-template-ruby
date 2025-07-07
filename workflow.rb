# frozen_string_literal: true

# @@@SNIPSTART money-transfer-project-template-ruby-workflow
require_relative 'activities'
require_relative 'shared'
require 'temporalio/retry_policy'
require 'temporalio/workflow'

module MoneyTransfer
  # Temporal Workflow that withdraws the specified amount from the source
  # account and deposits it into the target account, refunding the source
  # account if the deposit cannot be completed.
  class MoneyTransferWorkflow < Temporalio::Workflow::Definition
    def execute(details)
      retry_policy = Temporalio::RetryPolicy.new(
        max_interval: 10,
        non_retryable_error_types: [
          'InvalidAccountError',
          'InsufficientFundsError'
        ]
      )

      Temporalio::Workflow.logger.info("Starting workflow (#{details})")

      withdraw_result = Temporalio::Workflow.execute_activity(
        BankActivities::Withdraw,
        details,
        start_to_close_timeout: 5,
        retry_policy: retry_policy
      )
      Temporalio::Workflow.logger.info("Withdrawal confirmation: #{withdraw_result}")

      begin
        deposit_result = Temporalio::Workflow.execute_activity(
          BankActivities::Deposit,
          details,
          start_to_close_timeout: 5,
          retry_policy: retry_policy
        )
        Temporalio::Workflow.logger.info("Deposit confirmation: #{deposit_result}")

        "Transfer complete (transaction IDs: #{withdraw_result}, #{deposit_result})"
      rescue Temporalio::Error::ActivityError => e
        Temporalio::Workflow.logger.error("Deposit failed: #{e}")

        # Since the deposit failed, attempt to recover by refunding the withdrawal
        begin
          refund_result = Temporalio::Workflow.execute_activity(
            BankActivities::Refund,
            details,
            start_to_close_timeout: 5,
            retry_policy: retry_policy
          )
          Temporalio::Workflow.logger.info("Refund confirmation: #{refund_result}")

          "Transfer complete (transaction IDs: #{withdraw_result}, #{refund_result})"
        rescue Temporalio::Error::ActivityError => refund_error
          Temporalio::Workflow.logger.error("Refund failed: #{refund_error}")
        end
      end
    end
  end
end
# @@@SNIPEND

