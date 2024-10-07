// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing the ERC20 interface from OpenZeppelin library
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WrappedEmpressToken {
    // Token metadata
    string public name = "Wrapped Empress Token"; // Name of the wrapped token
    string public symbol = "WEMP"; // Symbol of the wrapped token

    // Reference to the underlying Empress Token (EMP)
    IERC20 public empressToken; 

    // Mapping to track the WEMP balance of each user
    mapping(address => uint256) public wrappedBalances; 

    // Total supply of WEMP currently in existence
    uint256 public totalWrappedSupply; 

    // Event emitted when tokens are wrapped
    event Wrapped(address indexed user, uint256 amount);

    // Event emitted when tokens are unwrapped
    event Unwrapped(address indexed user, uint256 amount);

    // Constructor to initialize the contract with the EMP token address
    constructor(address _empressTokenAddress) {
        empressToken = IERC20(_empressTokenAddress); // Set the EMP token address
    }

    // Function to wrap EMP tokens into WEMP
    function wrap(uint256 amount) external {
        // Require that the amount is greater than zero
        require(amount > 0, "Amount must be greater than zero");
        
        // Require that the sender has enough EMP tokens
        require(empressToken.balanceOf(msg.sender) >= amount, "Insufficient EMP balance");

        // Transfer EMP tokens from the sender to this contract
        empressToken.transferFrom(msg.sender, address(this), amount);

        // Update the user's WEMP balance
        wrappedBalances[msg.sender] += amount;

        // Update the total supply of WEMP
        totalWrappedSupply += amount;

        // Emit the Wrapped event
        emit Wrapped(msg.sender, amount);
    }

    // Function to unwrap WEMP tokens back into EMP
    function unwrap(uint256 amount) external {
        // Require that the amount is greater than zero
        require(amount > 0, "Amount must be greater than zero");
        
        // Require that the sender has enough WEMP tokens to unwrap
        require(wrappedBalances[msg.sender] >= amount, "Insufficient WEMP balance");

        // Update the user's WEMP balance
        wrappedBalances[msg.sender] -= amount;

        // Update the total supply of WEMP
        totalWrappedSupply -= amount;

        // Transfer EMP tokens back to the sender
        empressToken.transfer(msg.sender, amount);

        // Emit the Unwrapped event
        emit Unwrapped(msg.sender, amount);
    }

    // Function to get the WEMP balance of a specific account
    function balanceOf(address account) external view returns (uint256) {
        return wrappedBalances[account]; // Return the balance of the specified account
    }

    // Function to get the total supply of WEMP tokens
    function totalSupply() external view returns (uint256) {
        return totalWrappedSupply; // Return the total supply of WEMP
    }
}