# frozen_string_literal: true

require 'minitest/autorun'
require 'temporalio/testing'
require_relative '../activities'
require_relative '../shared'

module MoneyTransfer
  class MoneyTransferActivityTest < Minitest::Test
    def test_withdraw
      env = Temporalio::Testing::ActivityEnvironment.new
      details = MoneyTransfer::TransferDetails.new('A1001', 'B2002', 100, 'REF123')
      result = env.run(BankActivities::Withdraw.new, details)
      assert_equal('OKW-100-A1001', result)
    end

    def test_withdraw_fails_insufficient_funds
      env = Temporalio::Testing::ActivityEnvironment.new
      details = MoneyTransfer::TransferDetails.new('A1001', 'B2002', 500_000, 'REF123')
      err = assert_raises(MoneyTransfer::InsufficientFundsError) do
        env.run(BankActivities::Withdraw.new, details)
      end
      assert_equal('Transfer amount too large', err.message)
    end

    def test_deposit
      env = Temporalio::Testing::ActivityEnvironment.new
      details = MoneyTransfer::TransferDetails.new('A1001', 'B2002', 100, 'REF123')
      result = env.run(BankActivities::Deposit.new, details)
      assert_equal('OKD-100-B2002', result)
    end
  end
end

