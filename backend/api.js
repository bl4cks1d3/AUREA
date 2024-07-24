const { ApolloServer, gql } = require('apollo-server');
const { ethers } = require('ethers');

// Defina seu schema GraphQL
const typeDefs = gql`
  type Query {
    unlockTime: Int
    canWithdraw: Boolean
    balance: Float
  }

  type Mutation {
    withdraw: String
  }
`;

// Configure o provedor e o contrato
const provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545');
const contractAddress = '0x5fbdb2315678afecb367f032d93f642f64180aa3'; // Substitua pelo endereço do contrato implantado
const abi = [
  "function unlockTime() view returns (uint)",
  "function withdraw()",
  "function balance() view returns (uint)",
  "event Withdrawal(uint amount, uint when)"
];

const contract = new ethers.Contract(contractAddress, abi, provider);

// Defina os resolvers
const resolvers = {
  Query: {
    unlockTime: async () => {
      return await contract.unlockTime();
    },
    canWithdraw: async () => {
      const currentTime = Math.floor(Date.now() / 1000);
      const unlockTime = await contract.unlockTime();
      return currentTime >= unlockTime;
    },
    balance: async () => {
      const balance = await provider.getBalance(contractAddress);
      return ethers.formatEther(balance);
    }
  },
  Mutation: {
    withdraw: async (_, __, { signer }) => {
      const contractWithSigner = contract.connect(signer);
      try {
        await contractWithSigner.withdraw();
        return "Withdrawal successful";
      } catch (error) {
        return `Error: ${error.message}`;
      }
    }
  }
};

// Configure o Apollo Server
const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: () => {
    const signer = provider.getSigner();
    return { signer };
  }
});

server.listen({ port: 4000 }).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});
