// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/erc721/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/erc721/ERC721Metadata.sol';
import "./verifier.sol";

contract NFTPrize is ERC721Enumerable, ERC721Metadata("MagicCoin", "MAG") {
  address public verifierContractAddToTen;
  address public verifierMagicNumber;

  struct Puzzle {
    uint index;
    address addr;
    string tokenImage;
  }

  using Pairing for *;
  struct Proof {
    Pairing.G1Point a;
    Pairing.G2Point b;
    Pairing.G1Point c;
  }

  Puzzle[] public puzzles;

  mapping(uint => bool) tokenUniqueness;

  event PuzzleAdded(address addr, string tokenImage, uint puzzleId);

  function addPuzzle(address _addr, string _tokenImage) public {
    uint tokenId = puzzles.length;
    Puzzle memory puzzle = Puzzle(tokenId, _addr, _tokenImage);
    puzzles.push(puzzle);
    emit PuzzleAdded(_addr, _tokenImage, tokenId);
  }

  function mint(
    Proof memory proof, uint[1] memory input
  ) public returns(bool) {
    require(tokenUniqueness[a[0]] == false, "already submitted");

    bool result = Verifier(puzzles[puzzleIndex].addr).verifyTx(a, a_p, b, b_p, c, c_p, h, k, input);
    require(result, "incorrect proof");

    uint tokenId = ERC721Enumerable.totalSupply() + 1;
    ERC721Enumerable._mint(msg.sender, tokenId);
    ERC721Metadata._setTokenURI(tokenId, puzzles[puzzleIndex].tokenImage);
    tokenUniqueness[a[0]] = true;
    return result;
  }
}

contract Verifier {
  using Pairing for *;
  struct Proof {
    Pairing.G1Point a;
    Pairing.G2Point b;
    Pairing.G1Point c;
  }
  function verifyTx(
    Proof memory proof, uint[1] memory input
  ) public returns (bool r);
}
