pragma solidity >=0.8.0;

contract gmtoken{

    string public name = "gm Token";
    string public symbol = "GMT";
    uint256 public totalSupply;
    uint256 public minted = 0;
    uint8 public decimals = 18;
    uint256 public gm_per_day = 5;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public last_minted;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer (address indexed _from, address indexed _to, uint256 _value);
    event Approval (address indexed _owner, address indexed _spender, uint256 _value);
    event Gm(address indexed _to);
    
    constructor (uint256 _initialSupply){
        totalSupply = _initialSupply;
    }
  
    function transfer (address _to, uint256 _value) public returns (bool success){
        require (balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve (address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success){
        require (_value <= allowance[_from][msg.sender]);
        require (_value <= balanceOf[_from]);               
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }
    
    function gm() public returns (bool success){
        // Mint gm tokens
        require (minted + gm_per_day < totalSupply);
        require (block.timestamp - last_minted[msg.sender] > 23 hours);
        
        balanceOf[msg.sender] += gm_per_day;
        minted += gm_per_day;
        last_minted[msg.sender] = block.timestamp;
        
        emit Gm(msg.sender);

        return true;
    }

}