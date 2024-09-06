import "@redstone-finance/evm-connector/contracts/data-services/MainDemoConsumerBase.sol";

contract PriceBet is MainDemoConsumerBase{
    bytes32 symbol;
    uint256 public expected;
    int256 public outcome = 0;
    uint256 public end;
    uint256 public endLimit;
    mapping (address => int8) public bets;
    mapping (address => uint256) public stakes;
    mapping (address => bool) public claims;
    uint256 public yesPool;
    uint256 public noPool;

    constructor(
        bytes32 _symbol,
        uint256 _expected,
        uint256 _end
    ) {
        symbol = _symbol;
        expected = _expected;
        end = _end;
    }
    
    function validateTimestamp(uint256 receivedTimestampMilliseconds) public view virtual override { }

    function finalize() external {
        // require(block.timestamp > end, "In progress");
        // require(block.timestamp < (end + endLimit), "Passed the limit");
        require(outcome == 0, "Already finalized");

        uint256 answer = getOracleNumericValueFromTxMsg(symbol);
        if(answer >= expected) {
            outcome = 1;
        } else {
            outcome = -1;
        }
    }

    function placeBet(bool _outcome) public payable {
        require(msg.value != 0, "No value im bet");
        require(bets[msg.sender] == 0, "Bet already placed");
        // require(block.timestamp < (end - endLimit), "Passed the limit");

        if(_outcome) {
            bets[msg.sender] = 1;
            yesPool += msg.value;
        } else {
            bets[msg.sender] = -1;
            noPool += msg.value;
        }
        stakes[msg.sender] += msg.value;
    }

    function claim() public {
        require(outcome != 0, "Not finalized");
        require(bets[msg.sender] == outcome, "Did not win");
        require(claims[msg.sender] == false, "Already claimed");

        uint256 stake = stakes[msg.sender];
        payable (msg.sender).transfer(payout(stake));
        payable (msg.sender).transfer(stake);

        claims[msg.sender] = true;
    }

    function payout(uint256 bet) public view returns(uint256) {
        uint256 factor = 100000000;
        uint256 winningPool = outcome == 1 ? yesPool : noPool;
        require(bet <= winningPool, "Bet bigger than winning pool");
        uint256 losingPool = outcome == -1 ? noPool : yesPool;
        uint256 share = bet * factor / winningPool;
        return share * losingPool / factor;
    }
}
