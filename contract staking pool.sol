/**
 *Submitted for verification at BscScan.com on 2022-09-26
*/

// SPDX-License-Identifier: MIT

/**
 * W6 Game Stake Contract  
 * https://world6game.com

 * developer @gamer_noob_stream, blockchain dev

 */

pragma solidity ^0.8.0;


//Declaração do codificador experimental ABIEncoderV2 para retornar tipos dinâmicos
pragma experimental ABIEncoderV2;


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
*/


abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;
    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract Pausable is Context {

    event Paused(address account);

    event Unpaused(address account);

    bool private _paused;

    constructor() {
        _paused = false;
    }

    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    modifier whenPaused() {
        _requirePaused();
        _;
    }

    function paused() public view virtual returns (bool) {
        return _paused;
    }

    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (uint256);    

    function transfer(address to, uint256 amount) external returns (bool);
}


interface IUniswapV2Router {
    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}


interface IUniswapV2Pair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
    function getReserves() external view returns 
    (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);


}


interface IUniswapV2Factory {
    function getPair(address token0, address token1) external returns (address);
}


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
}


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract W6Stake is Pausable, Ownable, ReentrancyGuard {

    using SafeMath for uint256;
    using Address for address;

    uint256 tempo20diasMinimo = 1728000;
    uint256 tempo30dias = 2592000;
    uint256 tempo45dias = 3888000;
    uint256 tempo60dias = 5184000;
    uint256 tempo90dias = 7776000;
    uint256 tempo115dias = 9936000;

    uint256 public window3daysClaimAllowed = 3 days;
    uint256 public newBlockTime = 20 days;
    uint256 public timeOpenPoolsStake;
    uint256 public timeDeployContract;
    uint256 public claim24hrs = 24 hours;

    uint256 public amountTokensDepositedBUSD;
    uint256 public amountTokensDepositedBNB;
    uint256 public amountTokensInStakeBUSD;
    uint256 public amountTokensInStakeBNB;

    uint256 public quantosStakesForamFeitos;
    uint256 public quantosStakesBUSDForamFeitos;
    uint256 public quantosStakesBNBForamFeitos;
    
    uint256 public totalStakersOnBUSD;
    uint256 public totalStakersOnBNB;

    uint256 public totalEarnBUSDcontract;
    uint256 public totalEarnBNBcontract;
    uint256 public totalBUSDconvertedToBNB;
    uint256 public totalBUSDpaidToStakers;
    uint256 public totalBNBpaidToStakers;

    uint256 diferenceBUSDreceived;
    uint256 balanceBUSDafterPay;

    address public   W6address =            0x8dd435d3484AF2914a15463594e8DB1fd135e1B8;
    address internal BUSDaddress =          0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address internal UNISWAP_V2_ROUTER  =   0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal WBNBaddress =          0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    address[] public allAddressStakersBUSD;
    uint256[] public allWhatsNumberStakeBUSD;

    address[] public allAddressStakersBNB;
    uint256[] public allWhatsNumberStakeBNB;

    struct StakeInfoBUSD {        
        uint256 startStake1;
        uint256 startStake2;
        uint256 startStake3;
        uint256 amountTokens1;
        uint256 amountTokens2;
        uint256 amountTokens3;
    }
    struct ClaimInfoBUSD {        
        uint256 amountBUSDClaimed1;
        uint256 amountBUSDClaimed2;
        uint256 amountBUSDClaimed3;
        uint256 totalAmountClaimedBUSD;
    }
    struct StakeInfoBNB {        
        uint256 startStake1;
        uint256 startStake2;
        uint256 startStake3;
        uint256 amountTokens1;
        uint256 amountTokens2;
        uint256 amountTokens3;
    }
    struct ClaimInfoBNB {        
        uint256 amountBNBClaimed1;
        uint256 amountBNBClaimed2;
        uint256 amountBNBClaimed3;
        uint256 totalAmountClaimedBNB;
    }
    struct earnBUSDandBNB {
        uint256 whatsLastBalanceBUSDcontractStake1;
        uint256 whatsLastBalanceBUSDcontractStake2;
        uint256 whatsLastBalanceBUSDcontractStake3;
        uint256 whatsLastBalanceBNBcontractStake1;
        uint256 whatsLastBalanceBNBcontractStake2;
        uint256 whatsLastBalanceBNBcontractStake3;

    }

    event ApostouStaked(address indexed addressStaker, uint256 amountTokens, uint256 whichPool, uint256 numeroDaAposta);
    event Retirado(address indexed addressStaker, uint256 amountTokens, uint256 amountClaimed, uint256 totalRewardClaimed, uint256 whichPool, uint256 numeroDaAposta);

    mapping(address => StakeInfoBUSD) public mappingStakeInfoBUSD;
    mapping(address => StakeInfoBNB) public mappingStakeInfoBNB;
    mapping(address => ClaimInfoBUSD) public mappingClaimInfoBUSD;
    mapping(address => ClaimInfoBNB) public mappingClaimInfoBNB;

    mapping(address => earnBUSDandBNB) public mappingEarnBUSDandBNBcontract;

    receive() external payable { }

    constructor() {
        timeDeployContract = block.timestamp;
    }
   
    function getDaysPassed() public view returns (uint256){
        return (block.timestamp - timeOpenPoolsStake).div(1 days); 
    }

    function getMappingStakerInfoBUSD(address staker) external view returns (StakeInfoBUSD memory) {
        return mappingStakeInfoBUSD[staker];
    }

    function getMappingStakerInfoBNB(address staker) external view returns (StakeInfoBNB memory) {
        return mappingStakeInfoBNB[staker];
    }

    //as 4 funções seguintes retornam os arrays de todos stakes já feitos
    function getAllAddressStakersBUSD() public view returns (address[] memory) {
        return allAddressStakersBUSD;
    }

    function getAllWhatsNumberStakeBUSD() public view returns (uint256[] memory) {
        return allWhatsNumberStakeBUSD;
    }

    function getAllAddressStakersBNB() public view returns (address[] memory) {
        return allAddressStakersBNB;
    }

    function getAllWhatsNumberStakeBNB() public view returns (uint256[] memory) {
        return allWhatsNumberStakeBNB;
    }

    function getInfos(address staker, uint256 whichPool, uint256 whatsNumberStake) public view returns (uint256, uint256,uint256,uint256,uint256) {
        uint256 startStake;
        uint256 amountTokens;
        uint256 amountClaimed;
        uint256 amountTokensInStake;
        uint256 lastBalanceContract;

        if (whichPool == 1) {
            amountTokensInStake = amountTokensInStakeBUSD;
            if (whatsNumberStake == 1) {
                startStake = mappingStakeInfoBUSD[staker].startStake1;
                amountTokens = mappingStakeInfoBUSD[staker].amountTokens1;
                amountClaimed = mappingClaimInfoBUSD[staker].amountBUSDClaimed1;
                lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake1;
            } else if (whatsNumberStake == 2) {
                startStake = mappingStakeInfoBUSD[staker].startStake2;
                amountTokens = mappingStakeInfoBUSD[staker].amountTokens2;
                amountClaimed = mappingClaimInfoBUSD[staker].amountBUSDClaimed2;
                lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake2;
            } else if (whatsNumberStake == 3) {
                startStake = mappingStakeInfoBUSD[staker].startStake3;
                amountTokens = mappingStakeInfoBUSD[staker].amountTokens3;
                amountClaimed = mappingClaimInfoBUSD[staker].amountBUSDClaimed3;
                lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake3;
            }
        } else if (whichPool == 2) {
            amountTokensInStake = amountTokensInStakeBNB;
            if (whatsNumberStake == 1) {
                startStake = mappingStakeInfoBNB[staker].startStake1;
                amountTokens = mappingStakeInfoBNB[staker].amountTokens1;
                amountClaimed = mappingClaimInfoBNB[staker].amountBNBClaimed1;
                lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake1;
            } else if (whatsNumberStake == 2) {
                startStake = mappingStakeInfoBNB[staker].startStake2;
                amountTokens = mappingStakeInfoBNB[staker].amountTokens2;
                amountClaimed = mappingClaimInfoBNB[staker].amountBNBClaimed2;
                lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake2;
            } else if (whatsNumberStake == 3) {
                startStake = mappingStakeInfoBNB[staker].startStake3;
                amountTokens = mappingStakeInfoBNB[staker].amountTokens3;
                amountClaimed = mappingClaimInfoBNB[staker].amountBNBClaimed3;
                lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake3;
            }
        }
        return (startStake, amountTokens, amountClaimed, amountTokensInStake, lastBalanceContract);

    }

    function getMyTokensW6Depositados(address staker) external view returns (uint256) {
        return (mappingStakeInfoBUSD[staker].amountTokens1 + mappingStakeInfoBNB[staker].amountTokens1 +
                mappingStakeInfoBUSD[staker].amountTokens2 + mappingStakeInfoBNB[staker].amountTokens2 +
                mappingStakeInfoBUSD[staker].amountTokens3 + mappingStakeInfoBNB[staker].amountTokens3);
    }

    function getBUSDwasClaimed(address staker) external view returns (uint256) {
        return (mappingClaimInfoBUSD[staker].amountBUSDClaimed1 +
                mappingClaimInfoBUSD[staker].amountBUSDClaimed2 + 
                mappingClaimInfoBUSD[staker].amountBUSDClaimed3);
    }

    function getBNBwasClaimed(address staker) external view returns (uint256) {
        return (mappingClaimInfoBNB[staker].amountBNBClaimed1 +
                mappingClaimInfoBNB[staker].amountBNBClaimed2 + 
                mappingClaimInfoBNB[staker].amountBNBClaimed3);
    }

    function totalGetCalculateGanhosBUSD(address staker) public view returns (uint256) {
        return  getCalculateGanhosBUSD(staker,1) + 
                getCalculateGanhosBUSD(staker,2) + 
                getCalculateGanhosBUSD(staker,3); 
    }

    function totalGetCalculateGanhosBNB(address staker) public view returns (uint256) {
        return  getCalculateGanhosBNB(staker,1) + 
                getCalculateGanhosBNB(staker,2) + 
                getCalculateGanhosBNB(staker,3); 
    }

    function getCalculateGanhosBUSD(address staker, uint256 whatsNumberStake) public view returns (uint256){
        uint256 ganhosBUSD;
        uint256 amountTokens;
        uint256 startStake;
        uint256 lastBalanceContract;

        if (amountTokensInStakeBUSD == 0) {
            return 0;
        }

        (startStake, amountTokens, , , lastBalanceContract) = getInfos(staker,1,whatsNumberStake);

        uint256 percentTokens = (amountTokens.mul(10**6)).div(amountTokensInStakeBUSD);
        uint256 timeIncreaseFactorReturn;
        (, timeIncreaseFactorReturn) = getInfoTimeInscrease(startStake);
        uint256 amountIncreaseFactorCalc = amountIncreaseFactor(amountTokens);
        

        //divisão por 10^30 necessária 
        //percentTokens retorna 10^6 maior
        //getInfoTimeInscrease retorna um valor 10^8 maior
        //amountIncreaseFactor retorna um fator 10^8 maior
        uint256 getUpdateTotalBUSDdepositedReturn = getUpdateTotalBUSDdeposited() - lastBalanceContract;

        ganhosBUSD = getUpdateTotalBUSDdepositedReturn.mul(percentTokens)
        .mul(timeIncreaseFactorReturn).mul(amountIncreaseFactorCalc).div(10**22);

        if (ganhosBUSD >= getUpdateTotalBUSDdepositedReturn) {
            ganhosBUSD = getUpdateTotalBUSDdepositedReturn;
        }

        return ganhosBUSD;
    }

    function getCalculateGanhosBNB(address staker, uint256 whatsNumberStake) public view returns (uint256){
        uint256 ganhosBNB;
        uint256 amountTokens;
        uint256 startStake;
        uint256 lastBalanceContract;

        if (amountTokensInStakeBNB == 0) {
            return 0;
        }

        (startStake, amountTokens, , , lastBalanceContract) = getInfos(staker,2,whatsNumberStake);

        uint256 percentTokens = (amountTokens.mul(10**6)).div(amountTokensInStakeBNB);
        uint256 timeIncreaseFactorReturn;
        (, timeIncreaseFactorReturn) = getInfoTimeInscrease(startStake);
        uint256 amountIncreaseFactorCalc = amountIncreaseFactor(amountTokens);
            

        //divisão por 10^22 necessária 
        //percentTokens retorna 10^6 maior
        //getInfoTimeInscrease retorna um valor 10^8 maior
        //amountIncreaseFactor retorna um fator 10^8 maior
        uint256 balanceBNB = getUpdateTotalBNBdeposited() - lastBalanceContract;

        ganhosBNB = balanceBNB.mul(percentTokens)
        .mul(timeIncreaseFactorReturn).mul(amountIncreaseFactorCalc).div(10**22);
    
        if (ganhosBNB >= balanceBNB) {
            ganhosBNB = balanceBNB;
        } 

        return ganhosBNB;
    }


    function amountIncreaseFactor(uint256 amount) public pure returns (uint256) {
        uint256 factor;
        uint256 decimals = 18;

        if (amount <= 5000 * 10 ** decimals){
            factor = 100000000;
            return factor;
        } else if (amount > 5000 * 10 ** decimals && amount < 20000 * 10 ** decimals){
            factor = 104000000;
            return factor;
        } else if (amount >= 20000 * 10 ** decimals && amount < 70000 * 10 ** decimals) {
            factor = 111000000;
            return factor;
        } else if (amount >= 70000 * 10 ** decimals && amount < 150000 * 10 ** decimals) {
            factor = 130000000;
            return factor;
        } else if (amount >= 150000 * 10 ** decimals) {
            factor = 155000000;
            return factor;
        }
        return factor;
    }

    function getInfoTimeInscrease(uint256 startStake) public view returns (uint256, uint256) {
        uint256 time;
        uint256 timePassed;
        uint256 timeIncreaseFactorReturn;
        uint256 num;

        timePassed = block.timestamp - startStake;

        if (block.timestamp <= startStake + tempo20diasMinimo){
                        time = 1;
                        timePassed = timePassed.mul(10**6).mul(30);
                        timeIncreaseFactorReturn = timePassed.div(tempo20diasMinimo);
        } else if (block.timestamp < startStake + tempo30dias) {
                        time = 2;
                        timePassed = timePassed.mul(10**6).mul(50);
                        timeIncreaseFactorReturn = timePassed.div(tempo30dias);
        } else if (block.timestamp < startStake + tempo45dias) {
                        time = 3;
                        timePassed = timePassed.mul(10**6).mul(80);
                        timeIncreaseFactorReturn = timePassed.div(tempo45dias);
        } else if (block.timestamp < startStake + tempo60dias) {
                        time = 4;
                        timePassed = timePassed.mul(10**6).mul(100);
                        timeIncreaseFactorReturn = timePassed.div(tempo60dias);
        } else if (block.timestamp < startStake + tempo90dias) {
                        time = 5;
                        timePassed = timePassed.mul(10**6).mul(115);
                        timeIncreaseFactorReturn = timePassed.div(tempo90dias);
        } else if (block.timestamp < startStake + tempo115dias) {
                        time = 6;
                        timePassed = timePassed.mul(10**6).mul(125);
                        timeIncreaseFactorReturn = timePassed.div(tempo115dias);
        } else if (block.timestamp >= startStake + tempo115dias) {
                        time = 7;
                        num = 150;
                        timeIncreaseFactorReturn = num.mul(10**6);
        }

        return (time, timeIncreaseFactorReturn);
    }


    //retorna a atualização atual para o saldo de tokens depositados convertendo para BUSD para o calculo do APR e TVL
    function getConvertW6toBUSD(uint256 amount) public view returns (uint256) {
        uint256 retorno;
        if (amount != 0) {
            // generate the uniswap pair path of W6 to WBNB/BNB
            address[] memory path = new address[](3);
            path[0] = W6address;
            path[1] = WBNBaddress;
            path[2] = BUSDaddress;

            uint256[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER)
            .getAmountsOut(amount, path);
            retorno = amountOutMins[path.length -1];
        }
        return retorno;
    } 

    //retorna a atualização do BNB para BUSD
    function getConvertBNBtoBUSD(uint256 amount) public view returns (uint256) {
        uint256 retorno;
        if (amount != 0) {
            // generate the uniswap pair path of W6 to WBNB/BNB
            address[] memory path = new address[](2);
            path[0] = WBNBaddress;
            path[1] = BUSDaddress;

            uint256[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER)
            .getAmountsOut(amount, path);
            retorno = amountOutMins[path.length -1];
        }
        return retorno;
    } 

    //valor total bloqueado nas POOLS de stakes W6. Retorno em dólars
    function TVL (uint256 whichPool) public view returns (uint256,uint256) {
        uint256 liquidityTVL;
        uint256 liquidityForPay;


        //TVL geral para ambas POOLS
        if (whichPool == 0) {
            //convertendo a liquidez em tokens para BUSD
            liquidityTVL = getConvertW6toBUSD(amountTokensInStakeBUSD) + getConvertW6toBUSD(amountTokensInStakeBNB);
            //obtendo a liquidez disponível para pagamentos
            liquidityForPay = getUpdateTotalBUSDdeposited() + getConvertBNBtoBUSD(getUpdateTotalBNBdeposited());

        } else if (whichPool == 1) {
            liquidityTVL = getConvertW6toBUSD(amountTokensInStakeBUSD);
            liquidityForPay = getUpdateTotalBUSDdeposited();
        } else if (whichPool == 2) {
            liquidityTVL = getConvertW6toBUSD(amountTokensInStakeBNB);
            liquidityForPay = getConvertBNBtoBUSD(getUpdateTotalBNBdeposited());
        }
        return (liquidityTVL,liquidityForPay);
    }

    //based https://docs.pancakeswap.finance/products/yield-farming
    function APR (uint256 whichPool) public view returns (uint256) {
        uint256 denominator;
        uint256 liquidityForPay;

        //APR geral para ambas POOLS
        if (whichPool == 0) {
            //convertendo a liquidez em tokens para BUSD
            denominator = getConvertW6toBUSD(amountTokensInStakeBUSD) + getConvertW6toBUSD(amountTokensInStakeBNB);
            //obtendo a liquidez disponível para pagamentos
            liquidityForPay = getUpdateTotalBUSDdeposited() + getConvertBNBtoBUSD(getUpdateTotalBNBdeposited());

        } else if (whichPool == 1) {
            denominator = getConvertW6toBUSD(amountTokensInStakeBUSD);
            liquidityForPay = getUpdateTotalBUSDdeposited();
        } else if (whichPool == 2) {
            denominator = getConvertW6toBUSD(amountTokensInStakeBNB);
            liquidityForPay = getConvertBNBtoBUSD(getUpdateTotalBNBdeposited());
        }

        if (denominator == 0) {
            return 0;
        }

        uint256 timePassed = (block.timestamp - timeOpenPoolsStake).div(1 minutes);

        //disponibilidades da liquidez para pagamentos para a referida pool de stake
        uint256 liquidityProjectedForYarly = liquidityForPay.mul(10 ** 3).div(timePassed).mul(60).mul(24).mul(365);

        uint256 rewardsAPR = liquidityProjectedForYarly.div(denominator);

        //retorno multiplicado por 1.000
        return rewardsAPR;

    }

    function queryBalanceOf() public view returns (uint256) {
        return IERC20(BUSDaddress).balanceOf(address(this));
    }

    //consulta o saldo de BUSD já depositado no contrato
    function getUpdateTotalBUSDdeposited() public view returns (uint256) {
        uint256 addressThisBalanceOfBUSDReturn;

        addressThisBalanceOfBUSDReturn = 
        (queryBalanceOf() - balanceBUSDafterPay).div(2);

        return totalEarnBUSDcontract.div(2) + addressThisBalanceOfBUSDReturn;
    }

    //consulta o saldo de BNB disponível para pagamentos
    function getUpdateTotalBNBdeposited() public view returns (uint256) {
        uint256 addressThisBalanceReturn;

        uint256 diferenceBUSDreceivedTemp = queryBalanceOf() - balanceBUSDafterPay;
        if (diferenceBUSDreceivedTemp.div(2) != 0) {
            addressThisBalanceReturn = getUpdateBalanceBUSDtoBNB(diferenceBUSDreceivedTemp.div(2));
        }
        return totalEarnBNBcontract + addressThisBalanceReturn;
        }

    //atualiza o saldo de BUSD BNB no contrato para pagamento
    //deixa os saldos de BNB e BUSD atualizados ANTES da saída de BUSD
    function updateBUSDandBNBbeforePay() internal {

        //duas condições sempre são verdadeiras
        //contrato sempre recebe BUSD, seja ele ZERO ou maior que ZERO
        /*
        diferenceBUSDreceived sempre é maior que zero,
        motivo pelo qual um bug ou erro lógico nunca é esperado
        **/
        diferenceBUSDreceived = queryBalanceOf() - balanceBUSDafterPay;
        if (diferenceBUSDreceived != 0) {
            updateBalanceBUSDtoBNB(diferenceBUSDreceived.div(2));
        }
        totalBUSDconvertedToBNB += diferenceBUSDreceived.div(2);
        totalEarnBUSDcontract += diferenceBUSDreceived;
    }

    //atualiza infos dos BUSD recebidos e pagos. Função executada APÓS a saída de BUSD
    function updateInfoBUSDafterPay (uint256 amount) internal {
        totalBUSDpaidToStakers += amount; 
        balanceBUSDafterPay = queryBalanceOf();
    }

    //atualiza o saldo de BNB do contrato convertendo desde BUSD
    function updateBalanceBUSDtoBNB (uint256 amount) internal {

        uint256 initialBalance = address(this).balance;

        IERC20(BUSDaddress).approve(address(UNISWAP_V2_ROUTER), amount);
        // make the swap
        // generate the uniswap pair path of W6 to WBNB/BNB
        address[] memory path = new address[](2);
        path[0] = address(BUSDaddress);
        path[1] = address(WBNBaddress);

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForETH(amount, 0, path, address(this), block.timestamp);
        
        uint256 finalBalance = address(this).balance;
        totalEarnBNBcontract += (finalBalance - initialBalance);

    }
    
    //consulta a atualização atual para o saldo de BNB do contrato convertendo desde BUSD
    function getUpdateBalanceBUSDtoBNB(uint256 amount) public view returns (uint256) {
        
        uint256 retorno;
        // generate the uniswap pair path of W6 to WBNB/BNB
        address[] memory path = new address[](2);
        path[0] = BUSDaddress;
        path[1] = WBNBaddress;

        uint256[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER)
        .getAmountsOut(amount, path);
        return retorno = amountOutMins[path.length -1];
    }  

    function isAllowedClaimW6 () public view returns (bool) {
        if (block.timestamp <= 
        timeOpenPoolsStake + tempo20diasMinimo) {
            return false;
        } else if (block.timestamp <= 
        timeOpenPoolsStake + tempo20diasMinimo + window3daysClaimAllowed) {
            return true;
        } else if (block.timestamp <=
         timeOpenPoolsStake + tempo20diasMinimo + window3daysClaimAllowed + newBlockTime) {
            return false;
        } else {
            return true;
        }
    }

    function isAllowedClaim24hrsRewards (address staker, uint256 whichPool, uint256 whatsNumberStake) public view returns (bool) {
        uint256 startStake;
        (startStake, , , , ) = getInfos(staker,whichPool,whatsNumberStake);

        if (block.timestamp <= 
        startStake + claim24hrs) {
            return false;
        } else {
            return true;
        }
    }

    function StakeBUSD(address staker, uint256 whatsNumberStake, uint256 stakeAmount) external whenNotPaused {
        require(staker == _msgSender(), "Somente a conta detentora que pode apostar");
        require(stakeAmount > 0, "Por favor, aposte um valor de tokens maior que ZERO");
        require(IERC20(W6address).balanceOf(staker) >= stakeAmount, "Voce nao possui tokens suficientes");
        require(timeOpenPoolsStake != 0, "As pools de stake ainda nao estao abertas");
        require(whatsNumberStake <= 3 && whatsNumberStake != 0, "Stake fornecido invalido");
        
        IERC20(W6address).transferFrom(staker, address(this), stakeAmount);

        if (whatsNumberStake == 1) {
            require(mappingStakeInfoBUSD[staker].amountTokens1 == 0, "Voce ja fez seu primeiro stake");
            mappingStakeInfoBUSD[staker].startStake1 = block.timestamp;
            mappingStakeInfoBUSD[staker].amountTokens1 = stakeAmount;
            mappingClaimInfoBUSD[staker].amountBUSDClaimed1 = 0;

        } else if (whatsNumberStake == 2) {
            require(mappingStakeInfoBUSD[staker].amountTokens2 == 0, "Voce ja fez seu segundo stake");
            mappingStakeInfoBUSD[staker].startStake2 = block.timestamp;
            mappingStakeInfoBUSD[staker].amountTokens2 = stakeAmount;
            mappingClaimInfoBUSD[staker].amountBUSDClaimed2 = 0;

        } else if (whatsNumberStake == 3) {
            require(mappingStakeInfoBUSD[staker].amountTokens3 == 0, "Voce ja fez seu terceiro stake");
            mappingStakeInfoBUSD[staker].startStake3 = block.timestamp;
            mappingStakeInfoBUSD[staker].amountTokens3 = stakeAmount;
            mappingClaimInfoBUSD[staker].amountBUSDClaimed3 = 0;

        } else {
            require(false, "Limite de stake excedido");
        }

        allAddressStakersBUSD.push(staker);
        allWhatsNumberStakeBUSD.push(whatsNumberStake);

        quantosStakesForamFeitos++;
        quantosStakesBUSDForamFeitos++;
        totalStakersOnBUSD++;
        amountTokensDepositedBUSD += stakeAmount;
        amountTokensInStakeBUSD += stakeAmount;

        updateBUSDandBNBbeforePay();
        updateInfoBUSDafterPay(0);

        emit ApostouStaked(staker, stakeAmount, 1, whatsNumberStake);
    }    

    function StakeBNB(address staker, uint256 whatsNumberStake, uint256 stakeAmount) external whenNotPaused {
        require(staker == _msgSender(), "Somente a conta detentora que pode apostar");
        require(stakeAmount > 0, "Por favor, aposte um valor de tokens maior que ZERO");
        require(IERC20(W6address).balanceOf(staker) >= stakeAmount, "Voce nao possui tokens suficientes");
        require(timeOpenPoolsStake != 0, "As pools de stake ainda nao estao abertas");
        require(whatsNumberStake <= 3 && whatsNumberStake != 0, "Stake fornecido invalido");
        
        IERC20(W6address).transferFrom(staker, address(this), stakeAmount);

        if (whatsNumberStake == 1) {
            require(mappingStakeInfoBNB[staker].amountTokens1 == 0, "Voce ja fez seu primeiro stake");
            mappingStakeInfoBNB[staker].startStake1 = block.timestamp;
            mappingStakeInfoBNB[staker].amountTokens1 = stakeAmount;
            mappingClaimInfoBNB[staker].amountBNBClaimed1 = 0;

        } else if (whatsNumberStake == 2) {
            require(mappingStakeInfoBNB[staker].amountTokens2 == 0, "Voce ja fez seu segundo stake");
            mappingStakeInfoBNB[staker].startStake2 = block.timestamp;
            mappingStakeInfoBNB[staker].amountTokens2 = stakeAmount;
            mappingClaimInfoBNB[staker].amountBNBClaimed2 = 0;

        } else if (whatsNumberStake == 3) {
            require(mappingStakeInfoBNB[staker].amountTokens3 == 0, "Voce ja fez seu terceiro stake");
            mappingStakeInfoBNB[staker].startStake3 = block.timestamp;
            mappingStakeInfoBNB[staker].amountTokens3 = stakeAmount;
            mappingClaimInfoBNB[staker].amountBNBClaimed3 = 0;

        } 

        allAddressStakersBNB.push(staker);
        allWhatsNumberStakeBNB.push(whatsNumberStake);

        quantosStakesForamFeitos++;
        quantosStakesBNBForamFeitos++;
        totalStakersOnBNB++;
        amountTokensDepositedBNB += stakeAmount;
        amountTokensInStakeBNB += stakeAmount;

        updateBUSDandBNBbeforePay();
        updateInfoBUSDafterPay(0);

        emit ApostouStaked(staker, stakeAmount, 2, whatsNumberStake);
    }  

    function claimBUSD(address staker, uint256 whatsNumberStake) public whenNotPaused {
        require(staker == _msgSender() || _msgSender() == owner(), "Somente a conta detentora que pode clamar");

        uint256 amountTokens;
        uint256 startStake;
        uint256 lastBalanceContract;

        //contrato já possi várias proteções contra ataques hacker
        //as devidas alterações de saldos são feitas para evitar que um hacker drene os saldos do contrato

        if (whatsNumberStake == 1) {
            amountTokens = mappingStakeInfoBUSD[staker].amountTokens1;
            startStake = mappingStakeInfoBUSD[staker].startStake1;
            lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake1;

        } else if (whatsNumberStake == 2) {
            amountTokens = mappingStakeInfoBUSD[staker].amountTokens2;
            startStake = mappingStakeInfoBUSD[staker].startStake2;
            lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake2;

        } else if (whatsNumberStake == 3) {
            amountTokens = mappingStakeInfoBUSD[staker].amountTokens3;
            startStake = mappingStakeInfoBUSD[staker].startStake3;
            lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake3;

        } else {
            require(false, "Stake number invalido");
        }
           
        require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
        require(block.timestamp >= startStake + claim24hrs, "Tempo minimo de 24hrs para claim");

        //divisão por 10^22 necessária 
        //percentTokens retorna 10^6 maior
        //getInfoTimeInscrease retorna um valor 10^8 maior
        //amountIncreaseFactor retorna um fator 10^8 maior
        uint256 percentTokens = (amountTokens.mul(10**6)).div(amountTokensInStakeBUSD);
        (,uint256 timeIncreaseFactorReturn) = getInfoTimeInscrease(startStake);
        uint256 amountIncreaseFactorCalc = amountIncreaseFactor(amountTokens);
        uint256 ganhosBUSD;
        
        updateBUSDandBNBbeforePay();
        ganhosBUSD = (totalEarnBUSDcontract.div(2) - lastBalanceContract)
        .mul(percentTokens).mul(timeIncreaseFactorReturn).mul(amountIncreaseFactorCalc).div(10**22);

        if (ganhosBUSD >= IERC20(BUSDaddress).balanceOf(address(this))) {
            ganhosBUSD = IERC20(BUSDaddress).balanceOf(address(this));
        }

        IERC20(BUSDaddress).transfer(staker, ganhosBUSD);

        //ganhosBUSD é repassado para atualização, pois BUSD saiu do contrato
        updateInfoBUSDafterPay(ganhosBUSD);
        
        if (whatsNumberStake == 1) {
            mappingClaimInfoBUSD[staker].amountBUSDClaimed1 += ganhosBUSD;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake1 = totalEarnBUSDcontract.div(2);
        } else if (whatsNumberStake == 2) {
            mappingClaimInfoBUSD[staker].amountBUSDClaimed2 += ganhosBUSD;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake2 = totalEarnBUSDcontract.div(2);
        } else if (whatsNumberStake == 3) {
            mappingClaimInfoBUSD[staker].amountBUSDClaimed3 += ganhosBUSD;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake3 = totalEarnBUSDcontract.div(2);
        }

        mappingClaimInfoBUSD[staker].totalAmountClaimedBUSD += ganhosBUSD;
        uint256 totalAmountClaimedBUSDemit = mappingClaimInfoBUSD[staker].totalAmountClaimedBUSD;
        
        emit Retirado(staker, amountTokens, ganhosBUSD, totalAmountClaimedBUSDemit, 1, whatsNumberStake);
    }
    

    function claimBUSDandW6(address staker, uint256 whatsNumberStake) public whenNotPaused {
        require(staker == _msgSender() || _msgSender() == owner(), "Somente a conta detentora que pode clamar");

        if        (block.timestamp <= 
        timeOpenPoolsStake + tempo20diasMinimo) {
            require(false, "Stake com prazo minimo de 20 dias para retirar os tokens");
        } else if (block.timestamp <= 
        timeOpenPoolsStake + tempo20diasMinimo + window3daysClaimAllowed) {

        } else if (block.timestamp <=
         timeOpenPoolsStake + tempo20diasMinimo + window3daysClaimAllowed + newBlockTime) {
            require(false, "Stake com novo prazo de 20 dias para retirar os tokens");
        } else {

        }

        uint256 amountTokens;
        uint256 startStake;
        uint256 lastBalanceContract;

        //contrato já possi várias proteções contra ataques hacker
        //as devidas alterações de saldos são feitas para evitar que um hacker drene os saldos do contrato

        if (whatsNumberStake == 1) {
            amountTokens = mappingStakeInfoBUSD[staker].amountTokens1;
            require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
            startStake = mappingStakeInfoBUSD[staker].startStake1;
            lastBalanceContract  = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake1;
            mappingStakeInfoBUSD[staker].amountTokens1 = 0;

        } else if (whatsNumberStake == 2) {
            amountTokens = mappingStakeInfoBUSD[staker].amountTokens2;
            require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
            startStake = mappingStakeInfoBUSD[staker].startStake2;
            lastBalanceContract  = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake2;
            mappingStakeInfoBUSD[staker].amountTokens2 = 0;

        } else if (whatsNumberStake == 3) {
            amountTokens = mappingStakeInfoBUSD[staker].amountTokens3;
            require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
            startStake = mappingStakeInfoBUSD[staker].startStake3;
            lastBalanceContract  = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake3;
            mappingStakeInfoBUSD[staker].amountTokens3 = 0;

        } else {
            require(false, "Stake number invalido");
        }
           
        //divisão por 10^22 necessária 
        //percentTokens retorna 10^6 maior
        //getInfoTimeInscrease retorna um valor 10^8 maior
        //amountIncreaseFactor retorna um fator 10^8 maior
        uint256 percentTokens = (amountTokens.mul(10**6)).div(amountTokensInStakeBUSD);
        uint256 timeIncreaseFactorReturn;
        (, timeIncreaseFactorReturn) = getInfoTimeInscrease(startStake);
        uint256 amountIncreaseFactorCalc = amountIncreaseFactor(amountTokens);
        uint256 ganhosBUSD;


        updateBUSDandBNBbeforePay();
        ganhosBUSD = (totalEarnBUSDcontract.div(2) - lastBalanceContract)
        .mul(percentTokens).mul(timeIncreaseFactorReturn).mul(amountIncreaseFactorCalc).div(10**22);

        IERC20(W6address).transfer(staker, amountTokens);

        if (ganhosBUSD >= IERC20(BUSDaddress).balanceOf(address(this))) {
            ganhosBUSD = IERC20(BUSDaddress).balanceOf(address(this));
        }

        IERC20(BUSDaddress).transfer(staker, ganhosBUSD);

        //ganhosBUSD é repassado para atualização, pois BUSD saiu do contrato
        updateInfoBUSDafterPay(ganhosBUSD);
        
        if (whatsNumberStake == 1) {
            mappingClaimInfoBUSD[staker].amountBUSDClaimed1 += ganhosBUSD;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake1 = totalEarnBUSDcontract.div(2);
        } else if (whatsNumberStake == 2) {
            mappingClaimInfoBUSD[staker].amountBUSDClaimed2 += ganhosBUSD;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake2 = totalEarnBUSDcontract.div(2);
        } else if (whatsNumberStake == 3) {
            mappingClaimInfoBUSD[staker].amountBUSDClaimed3 += ganhosBUSD;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBUSDcontractStake3 = totalEarnBUSDcontract.div(2);
        }

        amountTokensInStakeBUSD -= amountTokens;
        totalStakersOnBUSD--;
        mappingClaimInfoBUSD[staker].totalAmountClaimedBUSD += ganhosBUSD;
        uint256 totalAmountClaimedBUSDemit = mappingClaimInfoBUSD[staker].totalAmountClaimedBUSD;
        
        emit Retirado(staker, amountTokens, ganhosBUSD, totalAmountClaimedBUSDemit, 1, whatsNumberStake);
    }

    function claimBNB (address staker, uint256 whatsNumberStake) public whenNotPaused {
        require(staker == _msgSender() || _msgSender() == owner(), "Somente a conta detentora que pode clamar");

        uint256 amountTokens;
        uint256 startStake;
        uint256 lastBalanceContract;

        //contrato já possi várias proteções contra ataques hacker
        //as devidas alterações de saldos são feitas para evitar que um hacker drene os saldos do contrato

        if (whatsNumberStake == 1) {
            amountTokens = mappingStakeInfoBNB[staker].amountTokens1;
            startStake = mappingStakeInfoBNB[staker].startStake1;
            lastBalanceContract  = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake1;

        } else if (whatsNumberStake == 2) {
            amountTokens = mappingStakeInfoBNB[staker].amountTokens2;
            startStake = mappingStakeInfoBNB[staker].startStake2;
            lastBalanceContract  = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake2;

        } else if (whatsNumberStake == 3) {
            amountTokens = mappingStakeInfoBNB[staker].amountTokens3;
            startStake = mappingStakeInfoBNB[staker].startStake3;
            lastBalanceContract  = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake3;

        } else {
            require(false, "Stake number invalido");
        }
        
        require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
        require(block.timestamp >= startStake + claim24hrs, "Tempo minimo de 24hrs para claim");

        //divisão por 10^22 necessária 
        //percentTokens retorna 10^6 maior
        //getInfoTimeInscrease retorna um valor 10^8 maior
        //amountIncreaseFactor retorna um fator 10^8 maior
        uint256 percentTokens = (amountTokens.mul(10**6)).div(amountTokensInStakeBNB);
        uint256 timeIncreaseFactorReturn;
        (, timeIncreaseFactorReturn) = getInfoTimeInscrease(startStake);
        uint256 amountIncreaseFactorCalc = amountIncreaseFactor(amountTokens);
        
        updateBUSDandBNBbeforePay();
        uint256 ganhosBNB = (totalEarnBNBcontract - lastBalanceContract)
        .mul(percentTokens).mul(timeIncreaseFactorReturn).mul(amountIncreaseFactorCalc).div(10**22);

        if (ganhosBNB != 0) {
            if (ganhosBNB < address(this).balance) {
                payable(staker).transfer(ganhosBNB);
            } else {
                ganhosBNB = address(this).balance;
                payable(staker).transfer(ganhosBNB);
            }
        }
        updateInfoBUSDafterPay(0);
        totalBNBpaidToStakers += ganhosBNB;

        if (whatsNumberStake == 1) {
            mappingClaimInfoBNB[staker].amountBNBClaimed1 += ganhosBNB;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake1 = totalEarnBNBcontract;
        } else if (whatsNumberStake == 2) {
            mappingClaimInfoBNB[staker].amountBNBClaimed2 += ganhosBNB;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake2 = totalEarnBNBcontract;
        } else if (whatsNumberStake == 3) {
            mappingClaimInfoBNB[staker].amountBNBClaimed3 += ganhosBNB;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake3 = totalEarnBNBcontract;
        }

        mappingClaimInfoBNB[staker].totalAmountClaimedBNB += ganhosBNB;
        uint256 totalAmountClaimedBNBemit = mappingClaimInfoBNB[staker].totalAmountClaimedBNB;

        emit Retirado(staker, amountTokens, ganhosBNB, totalAmountClaimedBNBemit, 2, whatsNumberStake);
    }


    function claimBNBandW6 (address staker, uint256 whatsNumberStake) public whenNotPaused {
        require(staker == _msgSender() || _msgSender() == owner(), "Somente a conta detentora que pode clamar");
        
        if        (block.timestamp <= 
        timeOpenPoolsStake + tempo20diasMinimo) {
            require(false, "Stake com prazo minimo de 20 dias para retirar os tokens");
        } else if (block.timestamp <= 
        timeOpenPoolsStake + tempo20diasMinimo + window3daysClaimAllowed) {

        } else if (block.timestamp <=
        timeOpenPoolsStake + tempo20diasMinimo + window3daysClaimAllowed + newBlockTime) {
            require(false, "Stake com novo prazo de 20 dias para retirar os tokens");
        } else {

        }

        uint256 amountTokens;
        uint256 startStake;
        uint256 lastBalanceContract;

        //contrato já possi várias proteções contra ataques hacker
        //as devidas alterações de saldos são feitas para evitar que um hacker drene os saldos do contrato

        if (whatsNumberStake == 1) {
            amountTokens = mappingStakeInfoBNB[staker].amountTokens1;
            require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
            startStake = mappingStakeInfoBNB[staker].startStake1;
            lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake1;
            mappingStakeInfoBNB[staker].amountTokens1 = 0;

        } else if (whatsNumberStake == 2) {
            amountTokens = mappingStakeInfoBNB[staker].amountTokens2;
            require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
            startStake = mappingStakeInfoBNB[staker].startStake2;
            lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake2;
            mappingStakeInfoBNB[staker].amountTokens2 = 0;

        } else if (whatsNumberStake == 3) {
            amountTokens = mappingStakeInfoBNB[staker].amountTokens3;
            require(amountTokens > 0, "Voce nao tem apostas e ganhos para retirar");
            startStake = mappingStakeInfoBNB[staker].startStake3;
            lastBalanceContract = mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake3;
            mappingStakeInfoBNB[staker].amountTokens3 = 0;

        } else {
            require(false, "Stake number invalido");
        }

        //divisão por 10^22 necessária 
        //percentTokens retorna 10^6 maior
        //getInfoTimeInscrease retorna um valor 10^8 maior
        //amountIncreaseFactor retorna um fator 10^8 maior
        uint256 percentTokens = (amountTokens.mul(10**6)).div(amountTokensInStakeBNB);
        uint256 timeIncreaseFactorReturn;
        (, timeIncreaseFactorReturn) = getInfoTimeInscrease(startStake);
        uint256 amountIncreaseFactorCalc = amountIncreaseFactor(amountTokens);
        
        IERC20(W6address).transfer(staker, amountTokens);

        updateBUSDandBNBbeforePay();
        uint256 ganhosBNB = (totalEarnBNBcontract - lastBalanceContract)
        .mul(percentTokens).mul(timeIncreaseFactorReturn).mul(amountIncreaseFactorCalc).div(10**22);
        
        if (ganhosBNB != 0) {
            if (ganhosBNB < address(this).balance) {
                payable(staker).transfer(ganhosBNB);
            } else {
                ganhosBNB = address(this).balance;
                payable(staker).transfer(ganhosBNB);
            }
        }

        updateInfoBUSDafterPay(0);
        totalBNBpaidToStakers += ganhosBNB;

        if (whatsNumberStake == 1) {
            mappingClaimInfoBNB[staker].amountBNBClaimed1 += ganhosBNB;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake1 = totalEarnBNBcontract;
        } else if (whatsNumberStake == 2) {
            mappingClaimInfoBNB[staker].amountBNBClaimed2 += ganhosBNB;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake2 = totalEarnBNBcontract;
        } else if (whatsNumberStake == 3) {
            mappingClaimInfoBNB[staker].amountBNBClaimed3 += ganhosBNB;
            mappingEarnBUSDandBNBcontract[staker].whatsLastBalanceBNBcontractStake3 = totalEarnBNBcontract;
        }

        amountTokensInStakeBNB -= amountTokens;
        totalStakersOnBNB--;
        mappingClaimInfoBNB[staker].totalAmountClaimedBNB += ganhosBNB;
        uint256 totalAmountClaimedBNBemit = mappingClaimInfoBNB[staker].totalAmountClaimedBNB;

        emit Retirado(staker, amountTokens, ganhosBNB, totalAmountClaimedBNBemit, 2, whatsNumberStake);
    }


    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function managerBNB () external onlyOwner {
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    function managerERC20 (address token) external onlyOwner {
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
    }

    function setOpenPoolsStake () external onlyOwner {
        timeOpenPoolsStake = block.timestamp;
    }

    function setTimes (
    uint256 _tempo20diasMinimo, 
    uint256 _window3daysClaimAllowed, 
    uint256 _claim24hrs, 
    uint256 _newBlockTime) external onlyOwner 
    {
        tempo20diasMinimo = _tempo20diasMinimo;
        window3daysClaimAllowed = _window3daysClaimAllowed;
        claim24hrs = _claim24hrs;
        newBlockTime = _newBlockTime;
    }

    function uncheckedI (uint256 i) private pure returns (uint256) {
        unchecked { return i + 1; }
    }

    function finalizePoolStake(address[] memory stakers, uint256[] memory whatsNumberStake, uint256 whichPool) 
    external onlyOwner {

        if (whichPool == 1) {
            for(uint256 i = 0; i < stakers.length; i = uncheckedI(i)) {  
                claimBUSDandW6(stakers[i], whatsNumberStake[i]);
            }

        } else {
            for(uint256 i = 0; i < stakers.length; i = uncheckedI(i)) {  
                claimBNBandW6(stakers[i], whatsNumberStake[i]);
            }
        }

    }
}
