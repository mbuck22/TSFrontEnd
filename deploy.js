const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const { abi, bytecode } = require('./compile'); 

const mnemonic = '/*taken out for safety*/';
const infuraUrl = 'https://sepolia.infura.io/v3/752742dd3a4d4e658f3434913ee97359';
const provider = new HDWalletProvider(mnemonic, infuraUrl);
const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log('Attempting to deploy from account:', accounts[0]);

    const contract = await new web3.eth.Contract(abi)
        .deploy({ data: bytecode, arguments: [10, web3.utils.toWei('1', 'ether')] })
        .send({ from: accounts[0], gas: '4700000', gasPrice: web3.utils.toWei('10', 'gwei') });

    console.log('Contract deployed to:', contract.options.address);

    provider.engine.stop();
};

deploy();
