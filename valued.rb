module Valued
  module ClassMethods
    def chart_digest(scope, options, date, time_range)
      objects = object_query(date, time_range, scope)
      {
        labels: objects.map(&:labels_helper),
        datasets: chart_datasets(objects, options)
      }
    end

    def label
      'must define a label method'
    end

    def chart_datasets(objects)
      [{
        label: label,
        data: objects.map(&:value)
      }]
    end

    def object_query(date, time_range, scope)
      by_date(date, time_range).where(scope)
    end
  end

  module InstanceMethods
    def labels_helper
      created_at.strftime('%d/%m')
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
