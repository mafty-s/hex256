# hex256
#Game Introduction
This game is a turn based card battle game. Players use currency to purchase cards or open card packs, combine the cards in their backpack reasonably, and engage in 1V1 battles with other users.

#Introduction to Cards

##Element Card
Three different elements of cards in the game: ocean, nature, and flames.
The three types each have more than twenty cards with different functionalities, including attack, defense, control, recovery, form transformation, and other different combat mechanisms. Players need to flexibly use card attributes to make reasonable combinations and combinations.
Hand attributes: The general attributes of each card are attack power, health, and magic consumption (using cards requires the consumption of the main body's magic).

##Universal Card
This type of card does not belong to any element, but only affects the acquisition of some resources in the game, including coins, magic points, etc.

#Game Process
##Matching
Users can engage in battles with other matching players by clicking the matching button; You can also engage in combat exercises with AI robots.

##Battle
After entering the battle, a player will be randomly arranged to take action. During the action, cards will be randomly drawn from their own pile, and players can place, attack, and release skills from opponent cards.
The battle area is divided into: hand area and table area. Attacking the opponent's hand area will cause damage to the opponent's body. When the body's health is 0, the battle ends.
Hand area: Cards in the hand area need to be placed in the table area to take effect, and after being placed, they cannot be attacked in the first round (except for special skills).
Table area: All cards need to be placed in the table area to be effective. When the opponent has cards in the table area, they cannot directly attack the opponent's hand area (except for special skills)

##Settlement
After each battle, points will be earned and the battle points will enter the ranking list

#Card bag purchase

Users can use currency to purchase random card packs, which have a chance to issue rare cards

play the demo: https://hex256.chedao.io/ 

run local chain:
```bash
cd ./webplayer_with_mud/packages/contracts
prum run dev
```

run client:
```bash
cd ./webplayer_with_mud/packages/client
pnpm run dev
```
