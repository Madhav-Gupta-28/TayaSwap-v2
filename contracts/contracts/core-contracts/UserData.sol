// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.7.0 < 0.9.0;
pragma abicoder v2;

contract UserStorageData{

     struct TransactionStruck{
        address caller;
        address poolAddress;
        address tokenAddress0;
        address tokenAddress1;
     }

     TransactionStruck[] transactions;

    // Add a new transaction to the array of transactions
     function addToBlockchain(address poolAddress, address tokenAddress0, address tokenAddress1) public{
        transactions.push(TransactionStruck(msg.sender, poolAddress, tokenAddress0, tokenAddress1));
     }

    // Get all transactions
    function getAllTransactions()public view returns(TransactionStruck[] memory) {
        return transactions;
    }

    // Get transactions by caller
    function getTransactionsByCaller(address caller)public view returns(TransactionStruck[] memory) {
        TransactionStruck[] memory result = new TransactionStruck[](transactions.length);
        uint counter = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].caller == caller) {
                result[counter] = transactions[i];
                counter++;
            }
        }
        return result;
    }

}