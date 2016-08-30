class Configuration < ApplicationRecord
  def value=(v)
    v = JSON.parse(v) if v.is_a?(String)
    super v
  end

  class << self
    def enabled?(key)
      value_enabled?(get(key))
    end

    def get(key)
      value = Configuration.find_by(key: key)&.value
      value.is_a?(Hash) ? value.with_indifferent_access : value
    end

    def get_value(key)
      get_path(key, :value)
    end

    # if the value is non-nil, return the key
    def get_path(key, *path)
      value = get(key)
      return unless value

      path.inject(value) do |obj, k|
        break unless obj
        obj[k]
      end
    end

    private

    def value_enabled?(value)
      value.try(:[], 'enabled')
    end
  end
end
