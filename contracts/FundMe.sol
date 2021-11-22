// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public addressToAmount;
    address public owner;
    address[] senders;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    function addressToAmountFunded(address _address)
        public
        view
        returns (uint256)
    {
        return addressToAmount[_address];
    }

    function fund() public payable {
        // $50
        uint256 minUSD = 50 * 10**18;
        require(
            getConversionRate(msg.value) >= minUSD,
            "You need to spend more ether!"
        );
        addressToAmount[msg.sender] += msg.value;
        senders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer) * 10000000000;
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        return (getPrice() * ethAmount) / 1000000000000000000;
    }

    function getEntranceFee() public view returns (uint256) {
        // minimumUSD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        for (
            uint256 funderIndex = 0;
            funderIndex < senders.length;
            funderIndex++
        ) {
            address funder = senders[funderIndex];
            addressToAmount[funder] = 0;
        }
        senders = new address[](0);
    }
}
