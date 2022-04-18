//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";

contract AddTo0 is ERC1155PresetMinterPauser {
    uint256 public constant ART = 0;
    uint256 public constant CONSUME = 1;
    uint256 public constant FINANCE = 2;
    uint256 public constant TECH = 3;

    constructor()
        ERC1155PresetMinterPauser(
            "https://addto0.digitalcompound.org/item/{id}.json"
        )
    {}

    function holderTokenSpeciesCount(address _holder)
        public
        view
        returns (uint256)
    {
        uint256 _count = 0;
        if (ERC1155.balanceOf(_holder, ART) > 0) _count++;
        if (ERC1155.balanceOf(_holder, CONSUME) > 0) _count++;
        if (ERC1155.balanceOf(_holder, FINANCE) > 0) _count++;
        if (ERC1155.balanceOf(_holder, TECH) > 0) _count++;
        return _count;
    }

    function holderTokenSpecies(address holder)
        public
        view
        returns (uint8[] memory)
    {
        uint8[] memory species = new uint8[](4);
        if (ERC1155.balanceOf(holder, ART) > 0) species[ART] = 1;
        if (ERC1155.balanceOf(holder, CONSUME) > 0) species[CONSUME] = 1;
        if (ERC1155.balanceOf(holder, FINANCE) > 0) species[FINANCE] = 1;
        if (ERC1155.balanceOf(holder, TECH) > 0) species[TECH] = 1;
        return species;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        if (to != address(0)) {
            // not a burn
            uint8[] memory species = holderTokenSpecies(to);
            for (uint256 i = 0; i < ids.length; i++) {
                if (species[ids[i]] == 0) {
                    species[ids[i]] = 1;
                }
            }
            uint8 count = 0;
            for (uint256 i = 0; i < species.length; i++) {
                if (species[i] > 0) count++;
            }
            require(count < 4, "too many tokens types");
        }
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
