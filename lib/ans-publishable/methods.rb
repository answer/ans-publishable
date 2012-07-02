module Ans::Publishable::Methods

  def publish(hash={})
    publish_id = nil

    retry_limit = 5
    count = 0
    begin

      transaction do
        publish_id = publish_model.create.send(publish_primary_key)
        where(publish_foreign_key => nil).send(publishable_scope,hash).update_all publish_foreign_key => publish_id
      end

    rescue => e
      count += 1
      if count < retry_limit
        retry
      else
        raise
      end
    end

    where(publish_foreign_key => publish_id)
  end

  def publishable_scope
    :publishable
  end
  def publish_model
    parent.const_get("#{model_name}Publish")
  end
  def publish_foreign_key
    "#{table_name.singularize}_publish_id".to_sym
  end
  def publish_primary_key
    :id
  end

end
