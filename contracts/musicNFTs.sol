// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract Nebula is ERC1155, Ownable, ERC1155Supply {

    struct Music {
        bytes32 name;
        string nftURI;
    }

    
    mapping(uint256 => Music) idToMusic;
    mapping(uint256 => address[]) ownerOf;

    uint256[] nftIds;

    constructor(
        bytes32 name, string memory link
    ) ERC1155(link) {}

    function _setURI(uint256 _id, bytes32 _music, string memory _newuri) internal{
       idToMusic[_id] = Music(_music, _newuri);
    }

    function _getURI(uint256 id) public view returns(bytes32, string memory){
        return (idToMusic[id].name, idToMusic[id].nftURI);
    }
    
    function setURI(uint256 id, bytes32 musicName, string memory newURI) public onlyOwner {
        for(uint256 i = 0; i < nftIds.length; i++){
            require(nftIds[i]!= id, "id already exists");
        }
        _setURI(id, musicName, newURI);
    }

    function mint(uint256 id, uint256 amount)
        public
        onlyOwner
    {
        _mint(msg.sender, id, amount, "");
        ownerOf[id].push(msg.sender);
    }

    function mintBatch( uint256[] memory ids, uint256[] memory amounts)
        public
        onlyOwner
    {
        _mintBatch(msg.sender, ids, amounts, "");
    }

    function uri(uint256 _id) public view override returns (string memory) {
            require(exists(_id), "URI: nonexistent token");

            return string(idToMusic[_id].nftURI);
    }

    function getOwner(uint256 id_) public view returns(address[] memory){
        return (ownerOf[id_]);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}