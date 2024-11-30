// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AnimalRegistry is ERC721Enumerable, Ownable {

    uint256 private _tokenIds;

    struct Animal {
        string name;
        string sex;
        uint256 age;
        string status;
        uint256 weight;
    }

    mapping(uint256 => Animal) private _animals;
    

    event AnimalMinted(uint256 tokenId, string name, string sex, uint256 age, string status, uint256 weight);

    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}

    function mintAnimal(
        string memory name,
        string memory sex,
        uint256 age,
        string memory status,
        uint256 weight

    ) public onlyOwner{
        _tokenIds++;

        uint256 newCattleId = _tokenIds;

        _mint(msg.sender, newCattleId);

        _animals[newCattleId] = Animal({
            name: name,
            sex: sex,
            age: age,
            status: status,
            weight: weight
        });

        emit AnimalMinted(newCattleId, name, sex, age, status, weight);

    }

    // save information about an animal

    function getAnimal(uint256 tokenId) public view returns (Animal memory){
        require(_ownerOf(tokenId) != address(0), "Cattle not found");
        return _animals[tokenId];
    }

  function getTokenIds(address _owner) public view returns (uint[] memory) {
        uint[] memory _tokensOfOwner = new uint[](ERC721.balanceOf(_owner));
        uint i;

        for (i=0;i<ERC721.balanceOf(_owner);i++){
            _tokensOfOwner[i] = ERC721Enumerable.tokenOfOwnerByIndex(_owner, i);
        }
        return (_tokensOfOwner);
    }
  

    function burnAnimal(uint256 tokenId) public {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");

        delete _animals[tokenId];

        _burn(tokenId);
    }
}
