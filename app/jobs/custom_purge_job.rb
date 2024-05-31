class CustomPurgeJob < ActiveStorage::PurgeJob
  queue_as { ActiveStorage.queues[:purge] }

  def perform(blob)
    p "blob is #{blob}"
    service = blob.service
    p "attachments are #{service}"
    p "blob key is #{blob.key}"
    service.delete(blob.key)
    blob.destroy
  end
end
