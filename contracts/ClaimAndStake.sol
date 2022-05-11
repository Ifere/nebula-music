// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./musicNFTs.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface INebula {
    //function balanceOf(address _user) external view returns(uint256);
    function getOwner(uint256 _tokenId) external view returns(address[] memory);
    function totalSupply() external view returns (uint256);
}


contract ClaimAndStake is ERC20("Nebula", "NEB"), Ownable{
    struct StreamSettings {
        uint256 baseRate;
        uint256 start;
    }

    StreamSettings public streamSettings;
    INebula public iNebula;

     // Prevents new contracts from being added or changes to disbursement if permanently locked
    bool public isLocked = false;
    mapping(bytes32 => uint256) public lastClaim;

    event RewardPaid(address indexed user, uint256 reward);

    constructor(address NebulaAddress, uint256 _baseRate) {
        iNebula = INebula(NebulaAddress);
        // initialize contractSettings
        streamSettings = StreamSettings({
        baseRate: _baseRate,
        start: 1653788572
        });
    }

    function claimReward(uint256 _tokenId) public returns (uint256) {
        address[] memory owners = iNebula.getOwner(_tokenId);
        for(uint256 i=0; i< owners.length; i++){
        require(owners[i] == msg.sender, "Caller does not own the token being claimed for.");
        }

        uint256 unclaimedReward = computeUnclaimedReward(_tokenId);

        // update the lastClaim date for tokenId and contractAddress
        bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
        lastClaim[lastClaimKey] = block.timestamp;

        // mint the tokens and distribute to msg.sender
        _mint(msg.sender, unclaimedReward);
        emit RewardPaid(msg.sender, unclaimedReward);

        return unclaimedReward;
    }

    function permanentlyLock() public onlyOwner {
        isLocked = true;
    }

    function getUnclaimedRewardAmount(uint256 _tokenId) public view returns (uint256) {
        return computeUnclaimedReward(_tokenId);
    }

    function computeAccumulatedReward(uint256 _lastClaimDate, uint256 _baseRate, uint256 currentTime) internal pure returns (uint256) {
        require(currentTime > _lastClaimDate, "Last claim date must be smaller than block timestamp");

        uint256 secondsElapsed = currentTime - _lastClaimDate;
        uint256 accumulatedReward = secondsElapsed * _baseRate / 1 days;

        return accumulatedReward;
    }

    function computeUnclaimedReward(uint256 _tokenId) internal view returns (uint256) {

        // Will revert if tokenId does not exist
        iNebula.getOwner(_tokenId);

        // build the hash for lastClaim based on contractAddress and tokenId
        bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
        uint256 lastClaimDate = lastClaim[lastClaimKey];
        uint256 baseRate = streamSettings.baseRate;

        // if there has been a lastClaim, compute the value since lastClaim
        if (lastClaimDate != uint256(0)) {
            return computeAccumulatedReward(lastClaimDate, baseRate, block.timestamp);
        }
        
        else {
            // if there has not been a lastClaim, add the initIssuance + computed value since contract startDate
            uint256 totalReward = computeAccumulatedReward(streamSettings.start, baseRate, block.timestamp);

            return totalReward;
        }
    }

    function getLastClaimedTime(uint256 _tokenId) public view returns (uint256) {

        bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));

        return lastClaim[lastClaimKey];
    }

    function getTotalUnclaimedRewardsForContract() public view returns (uint256) {
        uint256 totalUnclaimedRewards = 0;
        uint256 totalSupply = iNebula.totalSupply();

        for(uint256 i = 0; i < totalSupply; i++) {
            totalUnclaimedRewards += computeUnclaimedReward(i);
        }

        return totalUnclaimedRewards;
    }

    

}



