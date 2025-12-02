// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Crowdfunding {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    uint256 public creationFee = 0.001 ether;
    uint256 public contributionFee = 0.002 ether;

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 deadline;
        uint256 totalFunded;
        bool claimed;
    }

    Campaign[] public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;

    uint256 public treasury;

    // EVENTS
    event CampaignCreated(
        uint256 indexed id,
        address indexed creator,
        uint256 goal,
        uint256 deadline
    );

    event Contributed(
        uint256 indexed id,
        address indexed contributor,
        uint256 amount
    );

    event Withdrawn(
        uint256 indexed id,
        address indexed creator,
        uint256 amount
    );

    event Refunded(
        uint256 indexed id,
        address indexed contributor,
        uint256 amount
    );

    event GiftFromContract(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function setCreationFee(uint256 _fee) external onlyOwner {
        creationFee = _fee;
    }

    function setContributionFee(uint256 _fee) external onlyOwner {
        contributionFee = _fee;
    }

    function createCampaign(
        uint256 _goal,
        uint256 _durationInSeconds
    ) external payable {
        require(msg.value >= creationFee, "Fee not paid");
        require(_goal > 0, "Invalid goal");
        require(_durationInSeconds > 0, "Invalid duration");

        treasury += creationFee;

        uint256 deadline = block.timestamp + _durationInSeconds;

        campaigns.push(
            Campaign({
                creator: msg.sender,
                goal: _goal,
                deadline: deadline,
                totalFunded: 0,
                claimed: false
            })
        );

        emit CampaignCreated(campaigns.length - 1, msg.sender, _goal, deadline);
    }

    function contribute(uint256 _id) external payable {
        require(_id < campaigns.length, "Invalid id");

        Campaign storage c = campaigns[_id];
        require(block.timestamp < c.deadline, "Ended");
        require(msg.value > contributionFee, "Insufficient");

        uint256 donateAmount = msg.value - contributionFee;

        c.totalFunded += donateAmount;
        contributions[_id][msg.sender] += donateAmount;

        treasury += contributionFee;

        emit Contributed(_id, msg.sender, donateAmount);
    }

    function withdraw(uint256 _id) external {
        Campaign storage c = campaigns[_id];

        require(msg.sender == c.creator, "Not creator");
        require(block.timestamp >= c.deadline, "Not ended");
        require(c.totalFunded >= c.goal, "Goal not reached");
        require(!c.claimed, "Already claimed");

        c.claimed = true;

        uint256 amount = c.totalFunded;

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");

        emit Withdrawn(_id, msg.sender, amount);
    }

    function refund(uint256 _id) external {
        Campaign storage c = campaigns[_id];

        require(block.timestamp >= c.deadline, "Not ended");
        require(c.totalFunded < c.goal, "Goal reached");

        uint256 contributed = contributions[_id][msg.sender];
        require(contributed > 0, "Nothing");

        contributions[_id][msg.sender] = 0;

        (bool ok, ) = msg.sender.call{value: contributed}("");
        require(ok, "Refund failed");

        emit Refunded(_id, msg.sender, contributed);
    }

    function withdrawTreasury() external onlyOwner {
        uint256 amount = treasury;
        treasury = 0;

        (bool ok, ) = owner.call{value: amount}("");
        require(ok, "Treasury withdraw failed");
    }

    function giftFromContract(address _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Invalid address");
        require(_amount > 0, "Invalid amount");
        require(address(this).balance >= _amount, "Not enough balance");

        (bool ok, ) = _to.call{value: _amount}("");
        require(ok, "Gift failed");

        emit GiftFromContract(_to, _amount);
    }

    function getCampaign(
        uint256 _id
    )
        external
        view
        returns (
            address creator,
            uint256 goal,
            uint256 deadline,
            uint256 totalFunded,
            bool claimed
        )
    {
        Campaign storage c = campaigns[_id];
        return (c.creator, c.goal, c.deadline, c.totalFunded, c.claimed);
    }

    function getCampaignCount() external view returns (uint256) {
        return campaigns.length;
    }

    receive() external payable {}
}
