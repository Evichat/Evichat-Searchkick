module Searchkick
  class BulkReindexJob < ActiveJob::Base
    queue_as { Searchkick.queue_name }

    def perform(params)
      klass = params["class_name"].constantize
      index_name = params["index_name"]
      record_ids = params["record_ids"]
      method_name = params["method_name"]
      batch_id = params["batch_id"]
      min_id = params["min_id"]
      max_id = params["max_id"]
      index = index_name ? Searchkick::Index.new(index_name, **klass.searchkick_options) : klass.searchkick_index
      record_ids ||= min_id..max_id
      index.import_scope(
        Searchkick.load_records(klass, record_ids),
        method_name: method_name,
        batch: true,
        batch_id: batch_id
      )
    end
  end

  def locale
    return "en"
  end
end
