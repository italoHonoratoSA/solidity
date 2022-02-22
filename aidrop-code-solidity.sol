/**
Created by @gamer_noob_stream
In this telegram profile you have necessary information for contact*/


// SPDX-License-Identifier: MIT                        
                                                    
pragma solidity ^0.8.6;

contract ExampleLinesForAirdrop {


// @dev Airdrop function that makes the best verification of the positions [i] for locating and distributing the tokens
// @param calldata is necessary to indicate the explicit location of data for the variables of structure types 'address' and 'uint256'.
// @param An indication of the explicit localization of variables is mandatory as of solidity v0.5. See more at https://docs.soliditylang.org/en/v0.5.0/050-breaking-changes.html
interface IERC20 {

}

// Don't forget to use OpenZeppenlin's ERC20 and IERC20 standard
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

// @dev This function differs from the previous one by the economy of processing in the EVM, reducing the costs paid for gas,
// mainly on the first call of the function to the parameters.
function drop2 (address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {

        uint256 SCCC = 0;
        for(uint i=0; i < addresses.length; i++){
            SCCC = SCCC + tokens[i];
            _basicTransfer(from,addresses[i],tokens[i]);
        }

    }

}
