// Initialize ethers and contract
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();
const contractAddress = "0xD218e7E9e7D58841d59e8244e95F53df08226231"; // Replace with your contract address
const abi = [/* ABI from compile.js */];
const contract = new ethers.Contract(contractAddress, abi, signer);

// Functions
async function purchaseTicket() {
    const ticketId = document.getElementById("purchaseTicketId").value;
    try {
        const tx = await contract.buyTicket(ticketId, { value: ethers.utils.parseEther("1") });
        await tx.wait();
        document.getElementById("purchaseMessage").innerText = "Ticket purchased successfully!";
    } catch (error) {
        document.getElementById("purchaseMessage").innerText = `Error: ${error.message}`;
    }
}

async function offerSwap() {
    const ticketId = document.getElementById("swapTicketId").value;
    try {
        const tx = await contract.offerSwap(ticketId);
        await tx.wait();
        document.getElementById("swapMessage").innerText = "Swap offer submitted!";
    } catch (error) {
        document.getElementById("swapMessage").innerText = `Error: ${error.message}`;
    }
}

async function acceptOffer() {
    const ticketId = document.getElementById("acceptTicketId").value;
    try {
        const tx = await contract.acceptSwap(ticketId);
        await tx.wait();
        document.getElementById("acceptMessage").innerText = "Offer accepted!";
    } catch (error) {
        document.getElementById("acceptMessage").innerText = `Error: ${error.message}`;
    }
}

async function getTicketNumber() {
    const address = document.getElementById("walletAddress").value;
    try {
        const ticketId = await contract.getTicketOf(address);
        document.getElementById("ticketMessage").innerText = `Your ticket ID: ${ticketId}`;
    } catch (error) {
        document.getElementById("ticketMessage").innerText = `Error: ${error.message}`;
    }
}

async function returnTicket() {
    try {
        const tx = await contract.returnTicket();
        await tx.wait();
        document.getElementById("returnMessage").innerText = "Ticket returned successfully!";
    } catch (error) {
        document.getElementById("returnMessage").innerText = `Error: ${error.message}`;
    }
}

