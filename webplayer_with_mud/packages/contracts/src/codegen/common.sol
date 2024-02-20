// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */
enum SelectorType {
  None,
  SelectTarget,
  SelectorCard,
  SelectorChoice
}

enum RarityType {
  COMMON,
  UNCOMMON,
  RARE,
  MYTHIC
}

enum PackType {
  FIXED,
  RANDOM
}

enum TeamType {
  FIRE,
  FOREST,
  WATER,
  NEUTRAL
}

enum GameType {
  SOLO,
  ADVENTURE,
  MULTIPLAYER,
  HOST_P2P,
  OBSERVER
}

enum GameMode {
  CASUAL,
  RANKED
}

enum GameState {
  INIT,
  PLAY,
  GAME_ENDED
}

enum GamePhase {
  NONE,
  START_TURN,
  MAIN,
  END_TURN
}

enum CardType {
  None,
  Hero,
  Character,
  Spell,
  Artifact,
  Secret,
  Equipment
}

enum CardTeam {
  None,
  Green,
  Red,
  Blue
}

enum CardTrait {
  None,
  Wolf,
  Dragon
}

enum AbilityTrigger {
  NONE,
  ONGOING,
  ACTIVATE,
  ON_PLAY,
  ON_PLAY_OTHER,
  START_OF_TURN,
  END_OF_TURN,
  ON_BEFORE_ATTACK,
  ON_AFTER_ATTACK,
  ON_BEFORE_DEFEND,
  ON_AFTER_DEFEND,
  ON_KILL,
  ON_DEATH,
  ON_DEATH_OTHER
}

enum AbilityTarget {
  None,
  Self,
  PlayerSelf,
  PlayerOpponent,
  AllPlayers,
  AllCardsBoard,
  AllCardsHand,
  AllCardsAllPiles,
  AllSlots,
  AllCardData,
  PlayTarget,
  AbilityTriggerer,
  EquippedCard,
  SelectTarget,
  CardSelector,
  ChoiceSelector,
  LastPlayed,
  LastTargeted,
  LastDestroyed,
  LastSummoned
}

enum Team {
  FIRE,
  FOREST,
  WATER,
  NEUTRAL
}

enum Action {
  PlayCard,
  Attack,
  AttackPlayer,
  Move,
  CastAbility,
  SelectCard,
  SelectPlayer,
  SelectSlot,
  SelectChoice,
  CancelSelect,
  EndTurn,
  ChangeMana,
  AddStatus,
  ChangeCard
}

enum PileType {
  None,
  Board,
  Hand,
  Deck,
  Discard,
  Secret,
  Equipped,
  Temp
}

enum EffectStatType {
  None,
  Attack,
  HP,
  Mana
}

enum ConditionObjType {
  ConditionCardType
}

enum TraitData {
  Dragon,
  Growth,
  SpellDamage,
  Wolf
}

enum EffectAttackerType {
  Self,
  AbilityTriggerer,
  LastPlayed,
  LastTargeted
}

enum Status {
  None,
  Armor,
  Attack,
  Deathtouch,
  Flying,
  Fury,
  Hp,
  Intimidate,
  Invicibility,
  Lifesteal,
  Paralysed,
  Poisoned,
  Protected,
  Shell,
  Silenced,
  Sleep,
  SpellImmunity,
  Stealth,
  Taunt,
  Trample,
  Protection
}

enum ConditionStatType {
  None,
  Attack,
  HP,
  Mana
}

enum ConditionPlayerType {
  Self,
  Opponent,
  Both
}

enum ConditionOperatorInt {
  Equal,
  NotEqual,
  GreaterEqual,
  LessEqual,
  Greater,
  Less
}

enum ConditionOperatorBool {
  IsTrue,
  IsFalse
}

enum ConditionTargetType {
  None,
  Card,
  Player,
  Slot
}
