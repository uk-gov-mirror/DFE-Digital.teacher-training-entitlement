class Flow
  class << self
    def steps
      @steps ||= []
    end

    def step(name)
      steps << name
    end
  end

  def initialize(step_name)
    @step_name = step_name
  end

  def build_step(**args)
    step = step_class_for(@step_name).new(**args)
    return step if step.valid?

    loop do
      step = step_class_for(step.previous_step).new(**args)
      return step if step.valid? || step.previous_step == self.class.steps.first
    end
  end

private

  def step_class_for(name)
    "#{namespace}::Steps::#{name.to_s.camelize}Step".constantize
  end

  def step_classes
    self.class.steps.map do |name|
      "#{namespace}::Steps::#{name.to_s.camelize}Step".constantize
    end
  end

  def namespace
    self.class.name.deconstantize
  end
end
