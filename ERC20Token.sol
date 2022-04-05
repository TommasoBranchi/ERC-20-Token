pragma solidity ^0.7.1;
import "./IERC20Token.sol";

contract ERC20Token is IERC20Token
{
  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  address private _owner;
  uint256 private _totalSupply;

  string private _name;
  string private _symbol;
  uint private _decimals;

  constructor (string memory name , string memory symbol)
  {
    _name = name;
    _symbol = symbol;
    _decimals = 0;
    _owner = _msgSender();
  }

  function _msgSender() internal view returns (address)
  {
    return msg.sender;
  }
  function name() public view returns (string memory)
  {
    return _name;
  }
  function symbol() public view returns (string memory)
  {
    return _symbol;
  }
  function decimals() public view returns (uint256)
  {
    return _decimals;
  }
  function totalsupply() public view override returns (uint256)
  {
    return _totalSupply;
  }
  function balanceOf(address account) public view override returns (uint256)
  {
    return _balances[account];
  }
  function transfer(address recipient, uint256 amount) public virtual override returns (bool)
  {
    _transfer( _msgSender(), recipient , amount);
    return true;
  }
  function allowance(address owner , address spender) public view virtual override returns (uint256)
  {
    return _allowances[owner][spender];
  }
  function approve(address spender, uint256 amount) public virtual override returns (bool)
  {
    _approve( _msgSender() , spender , amount);
    return true;
  }
  function transferFrom(address sender , address recipient , uint256 amount) public virtual override returns (bool)
  {
    require(amount <= _allowances[sender][_msgSender()] , "La quantita inserita eccede rispetto a quella posseduta");
    _transfer(sender , recipient , amount);
    _approve(sender , _msgSender() , _allowances[sender][_msgSender()]);
    _allowances[sender][_msgSender()] -= amount;
    return true;
  }
  function increaseAllowance(address spender , uint256 addedValue) public virtual returns (bool)
  {
    _allowances[_msgSender()][spender] += addedValue;
    _approve(_msgSender() , spender , _allowances[_msgSender()][spender]);
    return true;
  }
  function decreaseAllowance(address spender , uint256 subtractedValue) public virtual returns (bool)
  {
    require(_allowances[_msgSender()][spender] - subtractedValue >= 0, "Quantita da aggiungere sotto lo 0");
    _allowances[_msgSender()][spender] -= subtractedValue;
    _approve(_msgSender() , spender , _allowances[_msgSender()][spender]);
    return true;
  }
  function _transfer(address sender, address recipient, uint256 amount) internal virtual
  {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
  }

  modifier OnlyOwner()
  {
    require(_msgSender() == _owner , "Non sei il proprietario del contratto");
    _;
  }
  function mint(address account , uint256 amount) public OnlyOwner virtual
  {
    require(account != address(0) , "Aggiunta da un indirizzo nullo");
    _totalSupply += amount;
    _balances[account] += amount;
    emit Transfer(address(0) , account , amount);
  }
  function _approve(address owner, address spender, uint256 amount) internal virtual
  {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
  }
  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
