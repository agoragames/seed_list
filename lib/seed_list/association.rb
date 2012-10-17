module SeedList
  module Association
    extend ActiveSupport::Concern

    module ClassMethods
      def seed(assoc_name)
        assoc_name = assoc_name.to_s

        SeedList.tournament_class_name = self.name
        SeedList.player_class_name = assoc_name.camelize

        eval "serialize :#{assoc_name}_seed_list, SeedList::List"

        assoc_name.classify.constantize.class_eval <<-CODE
          after_create  do |p| 
            p.#{self.name.downcase}.#{assoc_name}_seed_list.push(p.id)
            p.#{self.name.downcase}.save
          end

          after_destroy do |p|
            p.#{self.name.downcase}.#{assoc_name}_seed_list.delete(p.id)
            p.#{self.name.downcase}.save
          end

          def seed
            #{self.name.downcase}.#{assoc_name}_seed_list.find(id)
          end

          def seed=(n)
            #{self.name.downcase}.#{assoc_name}_seed_list.move(id, n)
            #{self.name.downcase}.save
          end
        CODE

      end
    end

  end
end

ActiveRecord::Base.send :include, SeedList::Association
