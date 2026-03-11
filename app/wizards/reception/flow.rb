module Reception
  class Flow < ::Flow
    step :start
    step :course_start_date
    step :cannot_register_yet
    step :choose_your_course
    step :choose_your_provider
    step :choose_school
    step :teacher_catchment
    step :work_setting
    step :ineligible_for_funding
    step :possible_funding
    step :share_provider
    step :check_answers
  end
end
