# frozen_string_literal: true

require 'minitest/autorun'
require 'temporalio/testing'
require 'temporalio/worker'
require_relative '../activities'
require_relative '../shared'
require_relative '../workflow'

module MoneyTransfer
  class MoneyTransferWorkflowTest < Minitest::Test
    def test_workflow
      Temporalio::Testing::WorkflowEnvironment.start_local do |env|
        worker = Temporalio::Worker.new(
          client: env.client,
          task_queue: "#{TASK_QUEUE_NAME}-test",
          activities: [BankActivities::Withdraw, BankActivities::Deposit],
          workflows: [MoneyTransferWorkflow]
        )
        worker.run do
          assert_equal(
            'Transfer complete (transaction IDs: OKW-100-A1001, OKD-100-B2002)',
            env.client.execute_workflow(MoneyTransferWorkflow,
                                        MoneyTransfer::TransferDetails.new('A1001', 'B2002', 100, 'REF123'),
                                        id: "wf-#{SecureRandom.uuid}",
                                        task_queue: worker.task_queue)
          )
        end
      end
    end
  end
end
