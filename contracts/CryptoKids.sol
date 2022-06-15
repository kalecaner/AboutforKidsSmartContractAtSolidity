// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.7;

contract CryptoKids{
    // owner DAD
    
     address owner;

     event LogKidFundingReceived(address addr,uint amount, uint contractBalance);
     constructor()
     {
         owner=msg.sender;

     }
// define kid
     struct Kid{
         address payable walletAddress;
         string fullName;
         string lastName;
         uint releaseTime;
         uint amount;
         bool canWithdraw;

     }
Kid[] public kids;
modifier onlyOwner() {
require(msg.sender==owner,"Only the owner can  add kids");
_;
} 

// add kid to contract
function addKid(address payable walletAddress,string memory fullName,string memory lastName,uint releaseTime,uint amount,bool canWithdraw) public onlyOwner {
    //require(msg.sender==owner,"Only the owner can  add kids");
    kids.push(Kid(
        walletAddress,
         fullName,
         lastName,
          releaseTime,
        amount,
         canWithdraw));
}

function balanceof() public view returns(uint){
    return address(this).balance;
}

//depeosit funds to contract specifically to  a kid's  account

function deposit ( address walletAddress) payable public{
addtoKidsBalance(walletAddress);

} 

function addtoKidsBalance(address walletAddress) private {

    for(uint i=0;i<kids.length;i++)
    {
        if(kids[i].walletAddress==walletAddress)
        {
            kids[i].amount+=msg.value;
            emit LogKidFundingReceived(walletAddress,msg.value,balanceof());
        }
    }
}



function getindex(address walletAddress) view private returns(uint){
    for(uint i=0;i<kids.length;i++)
    {
        if(kids[i].walletAddress==walletAddress)
        {
           return i;
        }
    }
    return 999;
}

 // kid checks if abble to withdraw
function availableTowithdraw(address walletAddress) public returns(bool)
{
uint i= getindex(walletAddress);
require(block.timestamp>kids[i].releaseTime,"You cannot withdraw yet");
if(block.timestamp>kids[i].releaseTime)
{
     kids[i].canWithdraw=true;
     return true;
    
}
return false;
}
// withdraw money
function withdraw(address payable  walletAddress) payable public{

    uint i = getindex(walletAddress);
    require(msg.sender==kids[i].walletAddress,"You must ve the kid to withdraw");
    require(kids[i].canWithdraw==true,"not withdraw yet"); 

    kids[i].walletAddress.transfer(kids[i].amount);
}

}