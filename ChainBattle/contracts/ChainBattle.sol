// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
  
    //属性结构
    struct Props { 
      uint256 levels;
      uint256 speed;
      uint256 strength;
      uint256 life;
   }
    Props props;
  
    mapping(uint256 => Props) public tokenIdToProps;npx hardhat verify --network mumbai

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 300 180">',
        '<style type="text/css"> .base { font-family: Arial; }.title { fill: black; font-size: 14px; font-weight: bolder; } .level { fill: black; font-size: 16px; font-style: ;} </style>',
        '<svg>',
        '<path fill="#ffffff" d="M 0.00 0.00 L 300.00 0.00 L 300.00 200.00 L 0.00 200.00 L 0.00 0.00 M 81.33 27.19 C 80.94 72.13 81.32 117.09 81.14 162.04 C 81.11 163.88 81.24 165.71 81.47 167.54 C 84.63 167.94 87.83 167.83 91.01 167.81 C 133.66 167.81 176.32 167.82 218.97 167.81 C 220.76 168.12 222.57 167.07 222.02 165.04 C 221.86 119.08 222.25 73.10 221.82 27.14 C 220.22 27.00 218.63 26.86 217.03 26.84 C 173.34 26.86 129.65 26.85 85.96 26.85 C 84.41 26.87 82.87 27.02 81.33 27.19 Z" /><path fill="#ffffff" d="M 84.13 29.88 C 129.08 29.72 174.04 29.81 219.00 29.83 C 219.05 74.83 219.15 119.84 218.95 164.84 C 174.02 164.90 129.09 164.91 84.17 164.83 C 84.08 119.85 84.15 74.86 84.13 29.88 Z" /><path fill="#131313" d="M 81.33 27.19 C 82.87 27.02 84.41 26.87 85.96 26.85 C 129.65 26.85 173.34 26.86 217.03 26.84 C 218.63 26.86 220.22 27.00 221.82 27.14 C 222.25 73.10 221.86 119.08 222.02 165.04 C 222.57 167.07 220.76 168.12 218.97 167.81 C 176.32 167.82 133.66 167.81 91.01 167.81 C 87.83 167.83 84.63 167.94 81.47 167.54 C 81.24 165.71 81.11 163.88 81.14 162.04 C 81.32 117.09 80.94 72.13 81.33 27.19 M 84.13 29.88 C 84.15 74.86 84.08 119.85 84.17 164.83 C 129.09 164.91 174.02 164.90 218.95 164.84 C 219.15 119.84 219.05 74.83 219.00 29.83 C 174.04 29.81 129.08 29.72 84.13 29.88 Z" />',
        '</svg>',
        '<text text-decoration="underline" x="40" y="45" class="title" dominant-baseline="middle" text-anchor="middle">',"SQUARE",'</text>',
        '<text x="42" y="65" class="base level" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getProps(tokenId).levels.toString(),'</text>',
        '<text x="42" y="85" class="base level" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getProps(tokenId).speed.toString(),'</text>',
        '<text x="42" y="105" class="base level" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getProps(tokenId).strength.toString(),'</text>',
        '<text x="42" y="125" class="base level" dominant-baseline="middle" text-anchor="middle">', "Life: ",getProps(tokenId).life.toString(),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}
function getProps(uint256 tokenId) public view returns (Props memory) {
        return  tokenIdToProps[tokenId];

}
function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}
function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToProps[newItemId] = Props(0,2,5,10);
    _setTokenURI(newItemId, getTokenURI(newItemId));
}
    function train(uint256 tokenId)public{
        require(_exists(tokenId));
        require(ownerOf(tokenId)==msg.sender,"You must own this token to train it");
        Props memory currentProps = tokenIdToProps[tokenId];
        tokenIdToProps[tokenId] = Props(currentProps.levels+1,currentProps.speed+2,currentProps.strength+5,currentProps.life+10);

        _setTokenURI(tokenId,getTokenURI(tokenId));
        }
}