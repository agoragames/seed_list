require 'thor'

module SeedList
  class CLI < Thor
    namespace :seed_list

    desc 'edit TOURNAMENT_ID', 'Reposition seeds using EDITOR (interactive)'
    def edit(tournament_id)
      @tournament_id = tournament_id
      trap_signals
      say "Using #{ENV['EDITOR']} (set $EDITOR to change)", :green
      say 'Loading environment...', :green
      say 'Exporting seed list...', :green

      old_list = players.map { |p| p.login }

      new_list = editor "tournament-#{tournament.id}-edit-seeds" do
        buffer =  "# Seed list for \"#{tournament.title}\" (##{tournament.id})\n\n"
        buffer << "# Organize the players below by skill from best to worst.\n"
        buffer << "# Save and quit to replace the seed list for this tournament.\n\n"

        buffer << old_list.join("\n")
      end.split("\n")
      system('clear')

      if new_list == old_list
        say 'Nothing changed.', :yellow
      else
        say 'Seed list updated, saving...', :green
        replace_seed_list new_list
      end
    end

    desc 'import TOURNAMENT_ID', 'Import line-separated seeds from STDIN'
    def import(tournament_id)
      @tournament_id = tournament_id
      trap_signals
      replace_seed_list STDIN.read.split("\n")
    end

    desc 'export TOURNAMENT_ID', 'Export line-separated seeds to STDOUT'
    def export(tournament_id)
      @tournament_id = tournament_id
      trap_signals
      players.each { |p| puts p.login }
    end

    no_tasks do

      def tournament
        begin
          @tournament ||= SeedList.tournament_class_name.constantize.find @tournament_id
        rescue ActiveRecord::RecordNotFound => e
          say e, :red
        end
      end

      def players
        eval("tournament.#{SeedList.player_class_name.tableize}")
          .sort_by { |tp| tp.seed }
      end

      def get_player_id(login)
        players.select { |p| p.login == login }.first.id
      end

      def replace_seed_list(logins)
        @list = SeedList::List.new

        logins.each do |login|
          begin
            @list.push get_player_id(login)
          rescue ActiveRecord::RecordNotFound => e
            say e, :red
          end
        end

        tournament.tournament_players_seed_list = @list
        tournament.save
      end

      # Terminate the program on SIGINT without printing a trace
      def trap_signals
        Signal.trap('INT') do
          say "\nQuitting...", :red
          Kernel.exit
        end
      end

      # Interactively manipulate data in a text editor.
      # @param [String] 'edit' Prefix for the tempfile
      # @param [Block] A block returning a text string for the buffer
      # @return [String] The updated text string (stripped of #comments and empty lines)
      # @example Change "hello" to "goodbye"
      #   editor 'edit-greeting' do
      #     "# This line is a comment\n\nhello"
      #   end => "goodbye"
      def editor(buffer_name = 'edit', &block)
        require 'tempfile'
        buffer = Tempfile.new(buffer_name + '-')
        buffer << yield
        buffer.flush
        system("$EDITOR #{buffer.path}")
        buffer.rewind
        output = buffer.read.split("\n")
          .reject { |line| line =~ /^\s*#.*$/ }
          .reject { |line| line.empty? }
        buffer.unlink
        output.join("\n")
      end

    end

  end
end
