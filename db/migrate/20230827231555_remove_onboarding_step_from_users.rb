class RemoveOnboardingStepFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :onboarding_step, :string
  end
end
