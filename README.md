# Temporal Money Transfer Ruby Project Template

The code in this repository demonstrates how to use the fundamental
building blocks, Workflows and Activities, with the Temporal Ruby SDK.
It simulates a money transfer between two bank accounts, illustrating
how to implement business logic for both success and failure scenarios.
This repository also serves as a template for creating new projects
that use the Temporal Ruby SDK.

Although you can run the example by executing the commands shown below, our
[Run your first app tutorial](https://docs.temporal.io/docs/ruby/run-your-first-app-tutorial)
provides more thorough coverage for this example.

Note: Code in this project uses Snipsync comment markers so that we can
automatically pull certain code snippets into the tutorial.


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


### Manually specifying input data

You can override each of those four parameters (source account, target
account, amount, and reference ID) using positional commandline parameters.
For example:


```command
bundle exec ruby starter.rb A123 B789 100 REF999
```

### Special Cases

In most cases, the Workflow Execution should succeed and you'll see a
confirmation message in the terminal window. You can also examine the
details in the Temporal Web UI (which should be available at this URL: 
<http://localhost:8233>).

There are two things that will trigger a different outcome:

1. If the transfer amount exceeds $1000, the withdrawal will fail due
   to insufficient funds. As per the custom Retry Policy in `workflow.rb`,
   this is defined as non-retryable. Since the Workflow does not provide
   special handling in this case, the Workflow Execution immediately fails.
2. If the target account is `B5555`, the deposit Activity will raise an
   `InvalidAccountError`. The Workflow provides special handling for this
    case by refunding the amount withdrawn back to the source account.


## Testing

The `test` directory contains automated tests for both the Workflow and
each Activity. You can execute these by running the following command
from the project root.

```command
bundle exec rake test
```
