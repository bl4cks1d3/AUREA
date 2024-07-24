const { ApolloServer, gql } = require('apollo-server');
const { ethers } = require('ethers');

// Defina seu schema GraphQL
const typeDefs = gql`
  type Professional {
    name: String
    profession: String
    registrationDate: Int
  }

  type Query {
    getProfessional(addr: String!): Professional
  }

  type Mutation {
    register(name: String!, profession: String!): String
    update(name: String!, profession: String!): String
  }
`;

// Configure o provedor e o contrato
const provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545');
const contractAddress = '0x5fbdb2315678afecb367f032d93f642f64180aa3'; // Substitua pelo endereço do contrato implantado
const abi = [
  "function register(string _name, string _profession) public",
  "function update(string _name, string _profession) public",
  "function getProfessional(address _addr) public view returns (string name, string profession, uint256 registrationDate)",
  "event ProfessionalRegistered(address indexed addr, string name, string profession, uint256 registrationDate)",
  "event ProfessionalUpdated(address indexed addr, string name, string profession)"
];

const contract = new ethers.Contract(contractAddress, abi, provider);

// Defina os resolvers
const resolvers = {
  Query: {
    getProfessional: async (_, { addr }) => {
      const [name, profession, registrationDate] = await contract.getProfessional(addr);
      return { name, profession, registrationDate };
    }
  },
  Mutation: {
    register: async (_, { name, profession }, { signer }) => {
      const contractWithSigner = contract.connect(signer);
      try {
        const tx = await contractWithSigner.register(name, profession);
        await tx.wait();
        return "Registration successful";
      } catch (error) {
        return `Error: ${error.message}`;
      }
    },
    update: async (_, { name, profession }, { signer }) => {
      const contractWithSigner = contract.connect(signer);
      try {
        const tx = await contractWithSigner.update(name, profession);
        await tx.wait();
        return "Update successful";
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
    // Use uma chave privada de uma das contas da rede Hardhat local
    const privateKey = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'; // Substitua pela chave privada da conta desejada
    const signer = new ethers.Wallet(privateKey, provider);
    return { signer };
  }
});

server.listen({ port: 4000 }).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});
