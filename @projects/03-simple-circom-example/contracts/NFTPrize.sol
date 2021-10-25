// SPDX-License-Identifier: MIT
pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./verifier.sol";

contract NFTPrize is ERC721("MagicCoin", "MAG"), Verifier {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  struct Puzzle {
    uint256 index;
    address addr;
    string tokenImage;
  }

  mapping(uint256 => bool) tokenUniqueness;

  function validateAndMintToken(
    uint[2] memory a,
    uint[2][2] memory b,
    uint[2] memory c,
    uint[1] memory input
  ) public returns (uint256) {
    require(verifyProof(a, b, c, input) == true, "invalid_proof");
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _mint(msg.sender, newItemId);
    return newItemId;
  }
}
