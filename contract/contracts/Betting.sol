// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract BettingContract {

    // === STATE VARIABLES ====

    // Bet options
   enum BettingOption { OptionA, OptionB }
    
    struct Participant {
        uint256 amountBet;
        bool optedForWinningSide;
        uint256 percentage;
    }
    
    mapping(address => Participant) public participants;
    uint256 public totalValue;
    uint256 public totalBetsOptionA;
    uint256 public totalBetsOptionB;
    uint256 public winningOption;
    bool public isBettingClosed;
    
    address public operator;

    // ==== CONSTRUCTOR ===== 
    constructor () {
        operator = msg.sender;
    }
    
    // ===== EVENTS ========
    event BetPlaced(address indexed participant, uint256 amount, BettingOption option);
    event RewardsDistributed(address indexed recipient, uint256 amount);


    //====== MODIFIERS ====== 
    modifier onlyOperator() {
        require(msg.sender == operator, "Only the operator can call this function");
        _;
    }
    
    modifier bettingOpen() {
        require(!isBettingClosed, "Betting is closed");
        _;
    }

    // ====== PLACEBET FUNCTION =======
    function placeBet(BettingOption _chosenOption) external payable bettingOpen {
        // check if option chosen is option A/B
        require(_chosenOption == BettingOption.OptionA || _chosenOption == BettingOption.OptionB, "Invalid option selected");
        
        // store the function caller into participants array
        Participant storage participant = participants[msg.sender];

        // checking if participant has placed a bet by checking if amountBet property equals 0
        require(participant.amountBet == 0, "Participant has already placed a bet");
        
        // setting participants bet amount to equal value
        participant.amountBet = msg.value;
        
        // sorting and calculating the total bets of each side
        if (_chosenOption == BettingOption.OptionA) {
            totalBetsOptionA += msg.value;
        } else {
            totalBetsOptionB += msg.value;
        }

        // adding msg.value to totalValue
        totalValue += msg.value;
        
        // emitting event if bet is placed
        emit BetPlaced(msg.sender, msg.value, _chosenOption);
    }


}