# Money Transfer Example Project (Ruby SDK)

The code in this repository demonstrates how to use the fundamental 
building blocks, Workflows and Activities, with the Temporal Ruby SDK. 
It simulates a money transfer between two bank accounts, illustrating 
how to implement business logic for both success and failure scenarios. 

## Step 1: Setup

Use the [temporal CLI](https://docs.temporal.io/cli) to start a local 
Temporal Service:


```command
temporal server start-dev
```

In a new terminal, clone the repository and change into the directory 
containing the source code:

```command
git clone https://github.com/temporalio/money-transfer-project-template-ruby
cd money-transfer-project-template-ruby
```

## Step 2: Run the Worker

The Worker is responsible for polling the Temporal Service for incoming 
requests, executing the Workflow and Activity code in response to those 
requests, and reporting the results back to the Temporal Service.

Since the progress of a Workflow Execution depends on having at least 
one Worker running, start a Worker by executing the following command:

```command
bundle exec ruby worker.rb
```

## Step 3: Start the Workflow

In a new terminal, run the following command to start the money transfer 
Workflow:

```command
bundle exec ruby starter.rb
```

This program submits a request to the Temporal Service, asking it to 
execute the Workflow with input data specified in the program. 

## Testing

The `test` directory contains automated tests for both the Workflow and 
each Activity. You can execute these by running the following command 
from the project root.

```command
bundle exec rake test
```
