// PDX-License-Identifier: MIT
pragma solidity >=0.8.21;



//public List<Card> cards_deck = new List<Card>();    //Cards in the player's deck
//public List<Card> cards_hand = new List<Card>();    //Cards in the player's hand
//public List<Card> cards_board = new List<Card>();   //Cards on the board
//public List<Card> cards_equip = new List<Card>();   //Cards equipped by characters
//public List<Card> cards_discard = new List<Card>(); //Cards in the player's discard
//public List<Card> cards_secret = new List<Card>();  //Cards in the player's secret area
//public List<Card> cards_temp = new List<Card>();    //Temporary cards that have just been created, not assigned to any zone yet


struct Player {
    uint8[] cards_deck;//Cards in the player's deck
    uint8[] cards_hand;//Cards in the player's hand
    uint8[] cards_board;//Cards on the board
    uint8[] cards_equip;//Cards equipped by characters
    uint8[] cards_discard;//Cards in the player's discard
    uint8[] cards_secret;//Cards in the player's secret area
    uint8[] cards_temp;//Temporary cards that have just been created, not assigned to any zone yet
}