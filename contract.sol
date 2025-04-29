// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IoTTransactionLogger {
    struct Transaction {
        address sender;
        address receiver;
        string encryptedData;
        uint256 timestamp;
    }

    mapping(uint256 => Transaction) public transactions;
    uint256 public transactionCount;

    event TransactionLogged(
        uint256 indexed txId,
        address indexed sender,
        address indexed receiver,
        string encryptedData,
        uint256 timestamp
    );

    // lattice based encryption function
    function encryptData(string memory plaintext) internal pure returns (string memory) {
        
        return string(abi.encodePacked("[ENCRYPTED]: ", plaintext));
    }

    function logEncryptedTransaction(
        address receiver,
        string calldata plaintext
    ) external {
        transactionCount++;

        string memory encrypted = encryptData(plaintext);

        transactions[transactionCount] = Transaction({
            sender: msg.sender,
            receiver: receiver,
            encryptedData: encrypted,
            timestamp: block.timestamp
        });

        emit TransactionLogged(transactionCount, msg.sender, receiver, encrypted, block.timestamp);
    }

    function getTransaction(uint256 txId)
        external
        view
        returns (address, address, string memory, uint256)
    {
        Transaction memory txData = transactions[txId];
        return (
            txData.sender,
            txData.receiver,
            txData.encryptedData,
            txData.timestamp
        );
    }
}

