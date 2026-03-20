class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    JSON.parse(value.to_json)
  rescue JSON::JSONError, TypeError
    record.errors.add(attribute, "deve ser um JSON válido")
  end
end
