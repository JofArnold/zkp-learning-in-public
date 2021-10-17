// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./verifier.sol";

contract NFTPrize is ERC721("MagicCoin", "MAG") {
    address public verifierContractAddToTen;
    address public verifierMagicNumber;

    struct Puzzle {
        uint256 index;
        address addr;
        string tokenImage;
    }

    using Pairing for *;
    //  @TODO
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }

    Puzzle[] public puzzles;

    mapping(uint256 => bool) tokenUniqueness;

    event PuzzleAdded(address addr, string tokenImage, uint256 puzzleId);

    function addPuzzle(address _addr, string memory _tokenImage) public {
        uint256 tokenId = puzzles.length;
        Puzzle memory puzzle = Puzzle(tokenId, _addr, _tokenImage);
        puzzles.push(puzzle);
        emit PuzzleAdded(_addr, _tokenImage, tokenId);
    }
}
