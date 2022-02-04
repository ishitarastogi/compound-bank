//SPDX-License-Identifier: Unlicense

pragma solidity >=0.7.0 <0.9.0;


interface cETH {
    
   // When you deposit ETH using the mint() function, Compound generates some cETH for you. 
    function mint() external payable; // to deposit to compound
    function redeem(uint redeemTokens) external returns (uint); // to withdraw from compound
    
    //following 2 functions to determine how much you'll be able to withdraw
    //exposes the number of ETH you can withdraw per cETH using exchangeRateStored.
    function exchangeRateStored() external view returns (uint); 
   // Compound exposes how many cETH a certain user holds using the function balanceOf. 
    function balanceOf(address owner) external view returns (uint256 balance);


//     ceth.balanceOf() gives us the number of cETH the user owns

// ceth.exchangeRateStored() gives us the number of ETH we’ll get per cETH
}


contract CompoundBank {


    uint totalContractBalance = 0;
    
    address COMPOUND_CETH_ADDRESS = 0x859e9d8a4edadfEDb5A2fF311243af80F85A91b8;
    cETH ceth = cETH(COMPOUND_CETH_ADDRESS);

    function getContractBalance() public view returns(uint){
        return totalContractBalance;
    }
    
    mapping(address => uint) balances;
    mapping(address => uint) depositTimestamps;
    
    function addBalance() public payable {
        balances[msg.sender] = msg.value;
        totalContractBalance = totalContractBalance + msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
        
        // send ethers to mint()
        ceth.mint{value: msg.value}();
        
    }
    //The current balance that a user can withdraw is the number of cETH they own multiplied by the exchange rate. Solidity doesn’t support floats and doubles. So exchangeRateStored is represented as an integer that must be divided by 10^18.
    function getBalance(address userAddress) public view returns(uint256) {
        return ceth.balanceOf(userAddress) * ceth.exchangeRateStored() / 1e18;
    }
    
    function withdraw() public payable {
        
        
        uint amountToTransfer = getBalance(msg.sender);
        
        totalContractBalance = totalContractBalance - amountToTransfer;
        balances[msg.sender] = 0;
        ceth.redeem(getBalance(msg.sender));
    }
    
    function addMoneyToContract() public payable {
        totalContractBalance += msg.value;
    }

    
}
