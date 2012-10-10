# SeedList
*Seed management for tournament brackets*

## Overview

SeedList is designed for Rails-powered tournament engines that need to persist
a 1-indexed ordered list of players (ranked low-to-high by skill or past performance)
and then match them up appropriately in the first round of a bracket.

Players are then matched up according to a strategy specified on a per-instance basis.

See also: https://github.com/agoragames/bracket_tree

## Example

```ruby

class Tournament < ActiveRecord::Base
  has_many :players
  seed :players
end

class Player < ActiveRecord::Base
  belongs_to :tournament
end
```

```ruby

add_column :tournaments, :players_seed_list, :text

```


```ruby

t = Tournament.create
 => #<Tournament id: 2, players_seed_list: #<SeedList::List:0x00000002aeff68 @list=[]>>

p = t.players.create
 => #<Player id: 16, tournament_id: 2> 

t.reload
 => #<Tournament id: 2, players_seed_list: #<SeedList::List:0x00000002d342d8 @list=[16]>> 

# Seed numbers start at 1
p.seed
 => 1

```

When a player is created, the `id` is pushed to the list in the highest (worst-place) seed
position. You can then move the seed to another position in the list.

```ruby

3.times { t.players.create }

p.seed = 4

t.reload
 => #<Tournament id: 2, players_seed_list: #<SeedList::List:0x00000002d342d8 @list=[17, 18, 19, 16]>> 

```

## Strategies

Once your players have been created and moved to the appropriate seed positions, you can use
the included seeding strategies to match them up appropriately in the first round of the bracket.

You can easily implement your own strategies as well. The initializer must accept an array
of objects that respond to #seed with an integer, and the #seed method must return an array
of those objects sorted appropriately as pairs.

```ruby

t.players.map { |p| p.seed }
 => [1, 2, 3 , 4]

# A Knockout tournament matches players at random. The seed position is irrelevant.
SeedList::Strategy::Knockout.new(t.players).seed.map { |p| p.seed }
 => [2, 3, 4, 1]

# A Playoff tournament matches the best players against the worst.
SeedList::Strategy::Playoff.new(t.players).seed.map { |p| p.seed }
 => [1, 4, 2, 3]

# An Amateur tournament matches by skill similarity straight down
SeedList::Strategy::Amateur.new(t.players).seed.map { |p| p.seed }
 => [1, 2, 3, 4]

```

## Utilities

SeedList includes a few [Thor](https://github.com/wycats/thor/) tasks to
make seeds easy to manage from the command line.

### Setup

Thor must load the Rails environment to import tasks from SeedList and other gems.

**lib/tasks/environment.thor**
```ruby
  require File.expand_path('config/environment')

```

    $ thor list
    seed_list
    ---------
    thor seed_list:edit TOURNAMENT_ID    # Reposition seeds using EDITOR (interactive)
    thor seed_list:export TOURNAMENT_ID  # Export line-separated seeds to STDOUT
    thor seed_list:import TOURNAMENT_ID  # Import line-separated seeds from STDIN


Your Player model is assumed to have a #login attribute to use these tasks.

### Examples

Export seeds to a file

    $ thor seed_list:export TOURNAMENT_ID > ./seeds
    $ cat seeds
    albafunk
    deborahbayerii
    ramonalockman
    danlind

Import seeds from a file

    $ cat ./seeds | thor seed_list:import TOURNAMENT_ID

Edit seeds in [VIM](http://www.vim.org/)

    $ EDITOR=vim thor seed_list:edit TOURNAMENT_ID

## License

See the [MIT-LICENSE](https://github.com/agoragames/seed_list/blob/master/MIT-LICENSE) file.

## Contributions

Contributions are awesome. Feature branch pull requests are the preferred method.

## Author

Written by [Logan Koester](https://github.com/logankoester)
