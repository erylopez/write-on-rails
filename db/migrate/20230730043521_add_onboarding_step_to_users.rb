class AddOnboardingStepToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :onboarding_step, :string, default: "step_1"
  end
end
