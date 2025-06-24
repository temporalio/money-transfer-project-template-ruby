# frozen_string_literal: true

require 'minitest/autorun'
require 'temporalio/testing'
require 'temporalio/worker'
require_relative '../activities'
require_relative '../shared'
require_relative '../workflow'

module MoneyTransfer
  class MoneyTransferWorkflowTest < Minitest::Test
    def setup
      @@env ||= Temporalio::Testing::WorkflowEnvironment.start_local
    end

    Minitest.after_run do
      @@env&.shutdown
    end

    def test_workflow
      worker = create_worker([BankActivities::Withdraw, BankActivities::Deposit])

      worker.run do
        assert_equal(
          'Transfer complete (transaction IDs: OKW-100-A1001, OKD-100-B2002)',
          @@env.client.execute_workflow(
            MoneyTransferWorkflow,
            MoneyTransfer::TransferDetails.new('A1001', 'B2002', 100, 'REF123'),
            id: "wf-#{SecureRandom.uuid}",
            task_queue: worker.task_queue
          )
        )
      end
    end

    def test_workflow_fails_if_insufficient_funds
      worker = create_worker([BankActivities::Withdraw, BankActivities::Deposit])

      worker.run do
        assert_raises(Temporalio::Error::WorkflowFailedError) do
          @@env.client.execute_workflow(
            MoneyTransferWorkflow,
            MoneyTransfer::TransferDetails.new('A1001', 'B2002', 500_000, 'REF123'),
            id: "wf-#{SecureRandom.uuid}",
            task_queue: worker.task_queue
          )
        end
      end
    end

    def create_worker(activities)
      Temporalio::Worker.new(
        client: @@env.client,
        task_queue: "#{TASK_QUEUE_NAME}-test",
        activities: activities,
        workflows: [MoneyTransferWorkflow]
      )
    end
  end
end

