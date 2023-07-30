module Onbordeable
  extend ActiveSupport::Concern

  included do
    state_machine :onboarding_step, initial: :step_1 do
      event :previous_step do
        transition step_2: :step_1, step_3: :step_2
      end

      event :reset_onboarding do
        transition any => :step_1
      end

      event :finish_flow do
        transition step_3: :step_4
      end

      event :complete_step_1 do
        transition step_1: :step_2
      end

      event :complete_step_2 do
        transition step_2: :step_3, if: :has_selected_a_writing_platform?
      end

      event :complete_step_3 do
        transition step_3: :step_4
      end
    end
  end

  def has_selected_a_writing_platform?
    notion_page_id.present?
  end

  def writing_platform_is_connected?
    true # optional atm
  end

  def next_step
    case onboarding_step
    when "step_1"
      complete_step_1
    when "step_2"
      complete_step_2
    when "step_3"
      complete_step_3
    end
  end
end
