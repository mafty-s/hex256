export enum SelectorType {
    NONE,
    SELECT_TARGET,
    SELECTOR_CARD,
    SELECTOR_CHOICE
}

export enum RarityType {
    COMMON,
    UNCOMMON,
    RARE,
    MYTHIC
}

export enum PackType {
    FIXED,
    RANDOM
}

export enum TeamType {
    FIRE,
    FOREST,
    WATER,
    NEUTRAL
}

export enum GameType {
    SOLO,
    ADVENTURE,
    MULTIPLAYER,
    HOST_P2P,
    OBSERVER
}

export enum GameMode {
    CASUAL,
    RANKED
}

export enum GameState {
    INIT,
    PLAY,
    GAME_ENDED
}

export enum GamePhase {
    NONE,
    START_TURN,
    MAIN,
    END_TURN
}

export enum CardType {
    NONE,
    HERO,
    CHARACTER,
    SPELL,
    ARTIFACT,
    SECRET,
    EQUIPMENT
}

export enum AbilityTrigger {
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

export enum AbilityTarget {
    NONE,
    SELF,
    PLAYER_SELF,
    PLAYER_OPPONENT,
    ALL_PLAYERS,
    ALL_CARDS_BOARD,
    ALL_CARDS_HAND,
    ALL_CARDS_ALL_PILES,
    ALL_SLOTS,
    ALL_CARD_DATA,
    PLAY_TARGET,
    ABILITY_TRIGGERER,
    EQUIPPED_CARD,
    SELECT_TARGET,
    CARD_SELECTOR,
    CHOICE_SELECTOR,
    LAST_PLAYED,
    LAST_TARGETED,
    LAST_DESTROYED,
    LAST_SUMMONED
}

export enum Team {
    FIRE,
    FOREST,
    WATER,
    NEUTRAL
}

export enum Action {
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
    AddStatus
}

export enum PileType {
    None,
    Board,
    Hand,
    Deck,
    Discard,
    Secret,
    Equipped,
    Temp
}

export enum EffectStatType {
    None,
    Attack,
    HP,
    Mana
}

export enum ConditionObjType {
    ConditionCardType
}

export enum TraitData {
    Dragon,
    Growth,
    SpellDamage,
    Wolf
}

export enum EffectAttackerType {
    Self,
    AbilityTriggerer,
    LastPlayed,
    LastTargeted
}

export enum Status {
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
}
