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
  end
end

