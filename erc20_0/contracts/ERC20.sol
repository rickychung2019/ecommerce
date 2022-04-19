pragma solidity >=0.4.22 < 0.7.0;

contract ERC20{
    uint256 total;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allow;
    
    constructor() public {
        // Set the total supply = 10000
        total = 10000;
        // Assign the total supply to the one who created the contract
        balances[msg.sender] = total;
    }

    // Transfer event
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // Approval event
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Returns the total number of tokens in the circulation
    function totalSupply() public view returns (uint256){
        return total;
    }

    // Returns the number of tokens of the address owner
    function balanceOf(address _owner) public view returns (uint256 balance){
        return balances[_owner];
    }

    // Transfer certain number of tokens from caller to the wallet address owner
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value ;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Transfer a number of tokens from an address to another address, the amount of tokens must be approved before transferred
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_from != _to);
        require(_value <= balances[_from]);
        require(_value <= allow[_from][msg.sender]);
        allow[_from][msg.sender] = allow[_from][msg.sender] - _value;
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Approve a certain number of tokens to be withdrawn from caller by spender
    function approve(address _spender, uint256 _value) public returns (bool success){
        allow[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Return the number of tokens that the spender can draw from the owner’s balance
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allow[_owner][_spender];
    }

    
}