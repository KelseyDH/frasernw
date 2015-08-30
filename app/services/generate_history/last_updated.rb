class GenerateHistory
  class LastUpdated < Base
    def exec
      return [] if target.created_at == target.last_updated_at

      [
        HistoryNode.new(
          target: target,
          user: target.last_updater,
          datetime: target.last_updated_at,
          verb: :last_updated,
          new_version: target,
          changeset: target.last_update_changeset
        )
      ]
    end
  end
end