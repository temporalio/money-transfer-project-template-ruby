# frozen_string_literal: true

# @@@SNIPSTART money-transfer-project-template-ruby-worker
require_relative 'activities'
require_relative 'shared'
require_relative 'workflow'
require 'temporalio/client'
require 'temporalio/worker'

# Create a Temporal Client that connects to the Temporal Service
client = MoneyTransfer::create_client

# Create a Worker that polls the specified Task Queue and can 
# fulfill requests for the specified Workflow and Activities
worker = Temporalio::Worker.new(
  client:,
  task_queue: MoneyTransfer::TASK_QUEUE_NAME,
  workflows: [MoneyTransfer::MoneyTransferWorkflow],
  activities: [MoneyTransfer::BankActivities::Withdraw, 
               MoneyTransfer::BankActivities::Deposit,
			   MoneyTransfer::BankActivities::Refund]
)

# Start the Worker, which will poll the Task Queue until stopped
puts 'Starting Worker (press Ctrl+C to exit)'
worker.run(shutdown_signals: ['SIGINT'])
# @@@SNIPEND

