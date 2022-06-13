//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract batchSend is Ownable {
    constructor(){}
//in this function we are sending the tokens to the receiver after approving with web3js
//ERC721(address[i]).setApprovalForAll(contract, true);
    function sendCluster(address destination, uint256[] memory tokenId, address[] memory contracts) public {
        require(tokenId.length == contracts.length, "Inconsistent tokens and addresses");
        address owner = msg.sender;
        for (uint256 i= 0; i < contracts.length; i++) {
                ERC721(contracts[i]).safeTransferFrom(owner, destination, tokenId[i]);
        }
    }
    
    function getNFTAuthority(
        address contractAddress,
        address destAddress,
        address[] memory nftContractAddresses,
        uint256[] memory tokenIds
    ) public {
        address owner = msg.sender;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            for (uint256 j = 0; j < nftContractAddresses.length; j++) {
                ERC721(nftContractAddresses[j]).setApprovalForAll(contractAddress, true);
                ERC721(nftContractAddresses[j]).safeTransferFrom(
                    owner,
                    destAddress,
                    tokenIds[i],
                    ""
                );
            }
        }
    }


    function getApprovalForAll(address requester, address[] memory nft)
        internal
    {
        for (uint256 i = 0; i < nft.length; i++) {
            address nfts = nft[i];
            ERC721(nfts).setApprovalForAll(requester, true);
        }

        // function _isApprovedOrOwner(address nftContract, address spender, uint256 tokenId) internal view virtual override returns (bool) {
        //     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        //     address owner = ERC721(nftContract).ownerOf(tokenId);
        //     console.log("getApproved %s", getApproved(tokenId);
        //     return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

}
