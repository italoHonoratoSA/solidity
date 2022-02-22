/**
Created by @gamer_noob_stream
Nesse telegram profile has necessary information for contact
*/


// SPDX-License-Identifier: MIT                        
                                                    
pragma solidity ^0.8.6;

contract ExempleLinesForAirdrop {


// @dev Airdrop function that makes the best verification of the positions [i] for locating and distributing two tokens
// @param calldata is necessary to indicate the explicit location of data for the variables of structure types 'address' and 'uint256'.
// @param An indication of the explicit localization of variables around it is mandatory as of solidity v0.5. See more at https://docs.soliditylang.org/en/v0.5.0/050-breaking-changes.html
interface IERC20 {

}

// No scheme to use the ERC20 and IERC20 standard of OpenZeppenlin
contract ERC20 is IERC20 {
    using SafeMath for uint256;

// @dev The visibility of this mapping function must be internal, because it needs to be accessed by other parties to the contract.
mapping(address => uint256) internal _balances;

// ***

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
}

function drop1 (address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
       
        uint256 count = 0;
        for(uint i=0; i < addresses.length; i++){
            count = count + tokens[i];
        }
        for(uint i=0; i < addresses.length; i++){
            _basicTransfer(from,addresses[i],tokens[i]);
        }

    }

// @dev This function is different from the previous one due to the economy of the process in the EVM, reducing the cost of gas payments,
// mainly in the first case of the function for the parameters.
function drop2 (address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {

        uint256 SCCC = 0;
        for(uint i=0; i < addresses.length; i++){
            SCCC = SCCC + tokens[i];
            _basicTransfer(from,addresses[i],tokens[i]);
        }

    }

}
