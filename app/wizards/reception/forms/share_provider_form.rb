module Reception
  module Forms
    class ShareProviderForm < StepForm
      attribute :can_share_choices, :string
      validates :can_share_choices, acceptance: true
    end
  end
end
