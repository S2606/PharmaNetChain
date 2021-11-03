pragma solidity >=0.7.0;

contract Owner{
    address private currentOwner;

    event transferOwnership(address indexed prevOwner, address indexed currOwner);

    constructor() {
        currentOwner = msg.sender;
        emit transferOwnership(address(0), currentOwner);
    }

    function owner() public view returns (address){
        return currentOwner;
    }

    function isOwner()  public view returns (bool){
        return msg.sender == currentOwner;
    }

    modifier checkOwner(){
        require(isOwner());
        _;
    }

    function dropOwnership() external checkOwner{
        emit transferOwnership(currentOwner, address(0));
        currentOwner = address(0);
    }

    function giveOwnership(address newOwner) external checkOwner{
        require(newOwner!=address(0));
        emit transferOwnership(currentOwner, newOwner);
        currentOwner = newOwner;
    }
}