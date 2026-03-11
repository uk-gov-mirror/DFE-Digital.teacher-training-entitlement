module Reception
  module Forms
    class KindOfNurseryForm < StepForm
      KIND_OF_NURSERY_OPTIONS = ReceptionRegistration::KIND_OF_NURSERY_PUBLIC_OPTIONS +
        ReceptionRegistration::KIND_OF_NURSERY_PRIVATE_OPTIONS

      attribute :kind_of_nursery

      validates :kind_of_nursery, presence: true, inclusion: { in: KIND_OF_NURSERY_OPTIONS }

      def options
        KIND_OF_NURSERY_OPTIONS
      end
    end
  end
end
