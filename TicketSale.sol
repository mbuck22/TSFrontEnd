// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract TicketSale {
	address public manager;
	uint public ticketPrice = 1;
	uint public totalTickets = 10;
    
	mapping(uint => address) public ticketOwners; //map ticketId to the owner address
	mapping(address => uint) public ticketOf; //map address to the ticketId
	mapping(uint => uint) public resaleTickets; //map ticketId to the resale price
	mapping(address => uint) public swapOffers; //map address to the ticketId to swap offers
    
	constructor(uint numTickets, uint price) { //constructor to set total number of tickets and ticket price
    	manager = msg.sender;
    	totalTickets = numTickets;
    	ticketPrice = price;
	}
    
	function buyTicket(uint ticketId) public payable {
    	require(ticketId > 0 && ticketId <= totalTickets, "Invalid ticket ID"); //ticketId is a valid ticket identifier
    	require(ticketOwners[ticketId] == address(0), "Ticket already sold"); //the ticket has not yet been sold
    	require(msg.value == ticketPrice, "Incorrect Ether sent"); //he or she sends the correct amount of ether
    	require(ticketOf[msg.sender] == 0, "You already own a ticket"); //the sender has not bought a ticket yet
    	ticketOwners[ticketId] = msg.sender; //sender buys ticket
    	ticketOf[msg.sender] = ticketId; //sender buys ticket
	}
    
	function getTicketOf(address person) public view returns (uint) {
    	return ticketOf[person]; //returns 0 by default if returns an unmapped address
	}

	function offerSwap(uint ticketId) public {
    	require(ticketOf[msg.sender] == ticketId, "You don't own this ticket");
    	swapOffers[msg.sender] = ticketId; //submits an offer for swapping
	}
    
	function acceptSwap(uint ticketId) public {
    	address offerer = ticketOwners[ticketId];
    	require(ticketOf[offerer] != 0, "You don't own a ticket");
    	require(swapOffers[offerer] != 0, "No swap offer found");
    	uint offererTicketId = ticketOf[offerer];
    	uint partnerTicketId = swapOffers[offerer];
    	address partner = ticketOwners[partnerTicketId];
    	ticketOwners[offererTicketId] = partner; //map offerer ticketId to partner address
    	ticketOwners[partnerTicketId] = offerer; //map partner ticketId to offerer address
    	ticketOf[offerer] = partnerTicketId; //map offerer address to the partner ticketId
    	ticketOf[partner] = offererTicketId; //map partner address to the offerer ticketId
    	delete swapOffers[offerer]; //offer is destroyed
	}
    
	function resaleTicket(uint price) public {
    	uint ticketId = ticketOf[msg.sender]; //get sender ticket ID
    	require(ticketId != 0, "You don't own a ticket"); //Sender can only submit a request if it has a ticket
    	resaleTickets[ticketId] = price; //offer resale value price for the ticket
	}

	function acceptResale(uint ticketId) public payable {
    	uint resalePrice = resaleTickets[ticketId];
    	require(resalePrice > 0, "Ticket not available for resale"); //succeeds only if the ticketId is on resale ticket list
    	require(msg.value == resalePrice, "Incorrect resale price"); //he/she sends the correct amount of ether/wei
    	require(ticketOf[msg.sender] == 0, "You already own a ticket");  //the sender has not bought a ticket yet
    	address seller = ticketOwners[ticketId];
    	uint managerFee = resalePrice / 10; //10% service fee
    	uint sellerCut = resalePrice - managerFee; //seller does not get service fee
    	payable(manager).transfer(managerFee); //pays out manager
    	payable(seller).transfer(sellerCut);  //pays out seller
    	ticketOwners[ticketId] = msg.sender; //sender gets ticket
    	ticketOf[msg.sender] = ticketId; //sender gets ticket
    	delete resaleTickets[ticketId]; //ticket should not show on the list of resale tickets
	}

	function checkResale() public view returns (uint[] memory) {
    	uint[] memory tickets = new uint[](totalTickets);
    	uint count = 0;
    	for (uint i = 1; i <= totalTickets; i++) {
        	if (resaleTickets[i] > 0) {
            	tickets[count] = i;
            	count++;
        	}
    	}
    	return tickets; //return array of tickets on resale list
	}
}

