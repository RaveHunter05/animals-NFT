// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721Burnable, Ownable {

    struct Animal {
        string name;
        string sex;
        uint256 age;
        string status;
        uint256 height;
        uint256 width;
    }

    mapping(uint256 => Animal) private _animals;

    event AnimalMinted(uint256 tokenId, string name, string sex, uint256 age, string status, uint256 height, uint256 width);

    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}

    function mintAnimal(
        address to,
        uint256 tokenId,
        string name,
        string sex,
        string age,
        string status,
        uint256 height, 
        uint256 width

    ) public onlyOwner{
        require(!_exists(tokenId), "Token ID already exists");

        _mint(to, tokenId);

        _animals[tokenId] = Animal({
            name: name,
            sex: sex,
            age: age,
            status: status,
            height: height,
            width: width
        });

        emit AnimalMinted(tokenId, name, sex, age, status, height, width);

    }

    // save information about an animal

    function getAnimal(uint256 tokenId) public view returns (string name, string sex, string age, string status, uint256 height, uint256 width){
        Animal storage animal = _animals[tokenId];
        return (animal.name, animal.sex, animal.age, animal.status, animal.height, animal.width);
    }

    function burnAnimal(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this token");

        delete _animals[tokenId]

        _burn(tokenId)
    }
}
