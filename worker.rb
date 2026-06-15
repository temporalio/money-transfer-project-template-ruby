# frozen_string_literal: true

# @@@SNIPSTART money-transfer-project-template-ruby-worker
require_relative 'activities'
require_relative 'shared'
require_relative 'workflow'
require 'logger'
require 'temporalio/client'
require 'temporalio/env_config'
require 'temporalio/worker'

# Connect to Temporal Cloud by loading the "cloud-setup" profile from the shared
# Temporal client config (temporal.toml), which supplies the Cloud address,
# namespace, TLS settings, and API key.
args, kwargs = Temporalio::EnvConfig::ClientConfig.load_client_connect_options(profile: 'cloud-setup')
client = Temporalio::Client.connect(*args, **kwargs, logger: Logger.new($stdout, level: Logger::INFO))

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

