// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./verifier.sol";

contract NFTPrize is ERC721, Verifier {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  struct Puzzle {
    uint256 index;
    address addr;
    string tokenImage;
  }

  mapping(uint256 => bool) tokenUniqueness;

  constructor() ERC721("MagicCoin", "MAG") {
    //
  }

  function validateAndMintToken(Proof memory proof, uint[1] memory inputs) public returns (uint256) {
    require(verifyTx(proof, inputs) == true, "invalid_proof");
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _mint(msg.sender, newItemId);
    return newItemId;
  }
}




