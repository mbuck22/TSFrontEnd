const solc = require('solc');
const fs = require('fs');
const path = require('path');

const contractPath = path.resolve(__dirname, 'contracts', 'TicketSale.sol');
const source = fs.readFileSync(contractPath, 'utf8');

const input = {
    language: 'Solidity',
    sources: {
        'TicketSale.sol': {
            content: source,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['abi', 'evm.bytecode.object'],
            },
        },
    },
};

const compiled = JSON.parse(solc.compile(JSON.stringify(input)));
const contract = compiled.contracts['TicketSale.sol']['TicketSale'];

fs.writeFileSync('TicketSaleABI.json', JSON.stringify(contract.abi, null, 2));
fs.writeFileSync('TicketSaleBytecode.txt', contract.evm.bytecode.object);

module.exports = { abi: contract.abi, bytecode: contract.evm.bytecode.object };

