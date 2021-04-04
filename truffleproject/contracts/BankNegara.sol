pragma solidity ^0.5.8;

contract Regulator {

    mapping(address => uint) private balances;
    address public owner;

    event LogDeposit(address indexed _accountOwner, uint _amount);
    event LogWithdraw(address indexed _accountOwner, uint _amount);
    event LogSuspicious(address indexed _accountOwner, uint _amount);
    event LogMessage(address indexed _accountOwner, string _message);

    constructor() public payable {
        owner = msg.sender;
        balances[msg.sender] = 10 ether;
    }

    function set_threshold(uint value, uint balance) internal {
        uint threshold_value = 10 ether;

        if (value > threshold_value) {
            emit LogMessage(msg.sender, "Huge transaction is being made.");
        }

        if (balance > 50 ether) {
            emit LogMessage(msg.sender, "Suspicious activity in this smart contract.");
        }

         emit LogSuspicious(msg.sender, value);

    }

    function deposit(uint deposit_amount) public payable returns (uint) {
        balances[msg.sender] += deposit_amount;
        emit LogDeposit(msg.sender, deposit_amount);
        set_threshold(deposit_amount, balances[msg.sender]);
        return balances[msg.sender];
    }

    function withdraw(uint withdraw_amount) public returns (uint) {
        if (withdraw_amount <= balances[msg.sender]) {
            balances[msg.sender] -= withdraw_amount;
            emit LogWithdraw(msg.sender, withdraw_amount);
            set_threshold(withdraw_amount, balances[msg.sender]);
        }
        return balances[msg.sender];
    }

    function check_balance() public view returns (uint) {
        return balances[msg.sender];
    }

}
