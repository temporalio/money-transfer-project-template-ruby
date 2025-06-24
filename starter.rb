# frozen_string_literal: true

require_relative 'shared'
require_relative 'workflow'
require 'securerandom'
require 'temporalio/client'

# Create the Temporal Client that the Worker will use to connect to the
# Temporal Service (in this case, it will connect to one running locally,
# on the standard port, and use the default namespace)
client = Temporalio::Client.connect('localhost:7233', 'default')

# Default values for the payment details (can override via positional commandline parameters)
details = MoneyTransfer::TransferDetails.new('A1001', 'B2002', 100, SecureRandom.uuid)
details.source_account = ARGV[0] if ARGV.length >= 1
details.target_account = ARGV[1] if ARGV.length >= 2
details.amount = ARGV[2].to_i if ARGV.length >= 3
details.reference_id = ARGV[3] if ARGV.length >= 4

# Use the Temporal Client to submit a Workflow Execution request to the
# Temporal Service, wait for the result returned by executing the Workflow,
# and then display that value to standard output.
handle = client.start_workflow(
  MoneyTransfer::MoneyTransferWorkflow,
  details,
  id: "moneytransfer-#{details.reference_id}",
  task_queue: MoneyTransfer::TASK_QUEUE_NAME
)

puts "Initiated transfer of $#{details.amount} from #{details.source_account} to #{details.target_account}"
puts "Workflow ID: #{handle.id}"

puts "Workflow result: #{handle.result}"
