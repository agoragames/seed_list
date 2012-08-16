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

