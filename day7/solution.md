# Solution

First, some notes:
- Ace is high, 2 is low
- A hand consists of 5 cards
- There are five types of hands, in descending order of strength:
    1. Five of a kind
    2. Four of a kind
    3. Full house
    4. Three of a kind
    5. Two pair
    6. One pair
    7. High card
- When two hands share the same classification (type), we compare each hand
  card-by-card. In the first pair of cards from the two hands that differ, the
  stronger hand is whichever has the higher value card.
- To get the solution of the game, we must find the ordering of hands that is
  strictly ascending. Each hand has an associated bid value. We sum the
  product of the card's position in the list with the bid value, and that sum
  is our answer.

# Hand classification
To facilitate the sorting and classification of hands, we will create a Hand
class with the following members:
- Hand: the string representation of the hand provided by the input
- Bid: the integer representing the bid provided by the input associated with
  the hand
- Type: An enum classifying which type of hand it is, with 1 being High card and
  7 being Five of a kind.

Hand class should also provide the following methods:
- Comparison operators: Return the hand with the higher type member, or in the
  case where both hands have the same type, iterate over the cards in each hand
  until you find an unmatched pairs of cards, returning the hand with the higher
  card.
- Equality operator: Return true if both cards have the same rank and the same
  hand member, otherwise return false

Furthermore, the constructor should perform the classification routine and
assign the type based on this classification. Here's how the algorithm will
work:
1. Create a frequency map for the hand, where keys are the card type and each
   frequency is initialized to 0.
2. Iterate over each card in the hand, incrementing the associated frequency for
   the given card.
3. Sort the frequency map into a list in descending order.
4. To classify:
    1. If the first element has a value of 5, type is five of a kind
    2. If the first element has a value of 4, type is four of a kind
    3. If the first element has a value of 3 and the second has a value of 2,
       type is full house
    4. If the first element has a value of 3 and the above is false, three of a
       kind
    5. If the first and second element have a value of 2, type is two pair
    6. If the first element has a value of 2 and the above is false, type is one
       pair
    5. Else type is high card.

# Sorting
In order to find the proper ordering, we will use a min heap.
