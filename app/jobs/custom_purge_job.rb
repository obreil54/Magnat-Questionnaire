class CustomPurgeJob < ActiveStorage::PurgeJob
  queue_as { ActiveStorage.queues[:purge] }

  def perform(blob)
    service = blob.service
    service.delete(blob.key)
    blob.destroy
  end
end
