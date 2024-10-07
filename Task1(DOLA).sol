// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for ERC20 tokens, defining essential functions
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
}

contract DolaToken {
    // Token metadata
    string public name = "DOLA Token"; // Name of the DOLA token
    string public symbol = "DOLA";       // Symbol of the DOLA token
    uint8 public decimals = 18;           // Decimal precision for DOLA

    // References to the collateral and pegged tokens
    IERC20 public roiToken;   // Reference to the upcoming ROI token
    IERC20 public bdolaToken; // Reference to the BDOLA collateral token

    // Mapping to track DOLA balances of users
    mapping(address => uint256) public balances;

    // Total supply of DOLA tokens in circulation
    uint256 public totalSupply;

    // Events to log minting and burning activities
    event Mint(address indexed user, uint256 amount);
    event Burn(address indexed user, uint256 amount);

    // Constructor to initialize the contract with ROI and BDOLA token addresses
    constructor(address _roiToken, address _bdolaToken) {
        roiToken = IERC20(_roiToken);     // Set the ROI token address
        bdolaToken = IERC20(_bdolaToken); // Set the BDOLA token address
    }

    // Function to mint DOLA tokens based on BDOLA collateral provided
    function mintDola(uint256 amount) external {
        // Ensure the amount is greater than zero
        require(amount > 0, "Amount must be greater than zero");

        // Transfer BDOLA from the user to this contract as collateral
        require(bdolaToken.transferFrom(msg.sender, address(this), amount), "Transfer of BDOLA failed");

        // Update the user's DOLA balance and total supply
        balances[msg.sender] += amount;
        totalSupply += amount;

        // Emit the Mint event
        emit Mint(msg.sender, amount);
    }

    // Function to burn DOLA tokens and retrieve the equivalent BDOLA collateral
    function burnDola(uint256 amount) external {
        // Ensure the amount is greater than zero
        require(amount > 0, "Amount must be greater than zero");

        // Check if the user has enough DOLA to burn
        require(balances[msg.sender] >= amount, "Insufficient DOLA balance");

        // Update the user's DOLA balance and total supply
        balances[msg.sender] -= amount;
        totalSupply -= amount;

        // Return BDOLA collateral to the user
        require(bdolaToken.transfer(msg.sender, amount), "Transfer of BDOLA failed");

        // Emit the Burn event
        emit Burn(msg.sender, amount);
    }

    // Function to check the DOLA balance of a specific account
    function balanceOf(address account) external view returns (uint256) {
        return balances[account]; // Return the DOLA balance for the specified account
    }

    // Function to get the total supply of DOLA tokens
    function getTotalSupply() external view returns (uint256) {
        return totalSupply; // Return the total supply of DOLA
    }
}
