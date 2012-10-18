module SeedList
  module Association
    extend ActiveSupport::Concern

    module ClassMethods
      def seed(assoc_name)
        assoc_name = assoc_name.to_s

        SeedList.tournament_class_name = self.name
        SeedList.player_class_name = assoc_name.camelize

        has_one :seed_list,
          as: :tournament,
          class_name: SeedList::Model,
          dependent: :destroy,
          readonly: true

        class_eval do
          def seed_list(skip_cache = true)
            super skip_cache
          end
        end

        after_create { |t| t.create_seed_list }

        seed_list_query = <<-QUERY
          SeedList::Model.where({
            tournament_id: p.#{self.name.downcase}_id,
            tournament_type: '#{self.name.to_s}'
          }).first
        QUERY

        assoc_name.classify.constantize.class_eval <<-PLAYER
          after_create do |p|
            seed_list = #{seed_list_query}
            seed_list.with_lock do
              seed_list.push(p.id)
              seed_list.save
            end
          end

          after_destroy do |p|
            seed_list = #{seed_list_query}
            seed_list.with_lock do
              seed_list.delete(p.id)
              seed_list.save
            end
          end

          def seed
            p = self
            #{seed_list_query}.find(id)
          end

          def seed=(n)
            p = self
            seed_list = #{seed_list_query}
            seed_list.with_lock do
              seed_list.move(id, n)
              seed_list.save
            end
          end
        PLAYER

      end

    end

  end
end

ActiveRecord::Base.send :include, SeedList::Association
