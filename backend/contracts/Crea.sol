// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CREA is Ownable {
    struct Registro {
        string nome;
        string[] documentos;
        bool temporario;
        bool valido;
    }

    struct Proposta {
        string descricao;
        address[] participantes;
        uint256 votosSim;
        uint256 votosNao;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => Registro) private registros;
    mapping(address => mapping(address => uint8)) private niveisAcesso;
    mapping(uint256 => Proposta) private propostas;
    mapping(uint256 => mapping(address => bool)) private votos;

    uint256 private numPropostas;

    event RegistroCriado(address indexed profissional, string nome, string[] documentos);
    event RegistroAtualizado(address indexed profissional, string campo, string valor);
    event RegistroTemporarioGerenciado(address indexed profissional, bool status);
    event NiveisAcessoAtualizados(address indexed profissional, address indexed usuario, uint8 nivel);
    event PropostaCriada(uint256 indexed propostaId, string descricao, address[] participantes);
    event PropostaVotada(uint256 indexed propostaId, address indexed votante, bool voto);
    event PropostaConsultada(uint256 indexed propostaId, string descricao, address[] participantes, uint256 votosSim, uint256 votosNao);
    event VotoConsultado(uint256 indexed propostaId, address indexed votante, bool voto);
    event RegistroValido(address indexed profissional);
    event RegistroInvalido(address indexed profissional);

    modifier somenteComAcesso(address profissional) {
        require(niveisAcesso[profissional][msg.sender] > 0, "Voce nao tem acesso ao registro deste profissional.");
        _;
    }

    function registrarProfissional(address profissional, string memory nome, string[] memory documentos) public onlyOwner {
        require(bytes(registros[profissional].nome).length == 0, "Profissional ja registrado.");
        
        registros[profissional] = Registro({
            nome: nome,
            documentos: documentos,
            temporario: false,
            valido: true
        });

        emit RegistroCriado(profissional, nome, documentos);
    }

    function atualizarRegistro(address profissional, string memory campo, string memory valor) public somenteComAcesso(profissional) {
        Registro storage registro = registros[profissional];
        
        if (keccak256(abi.encodePacked(campo)) == keccak256(abi.encodePacked("nome"))) {
            registro.nome = valor;
        } else if (keccak256(abi.encodePacked(campo)) == keccak256(abi.encodePacked("documentos"))) {
            string[] memory documentos = splitString(valor);
            registro.documentos = documentos;
        } else if (keccak256(abi.encodePacked(campo)) == keccak256(abi.encodePacked("temporario"))) {
            registro.temporario = parseBool(valor);
        } else if (keccak256(abi.encodePacked(campo)) == keccak256(abi.encodePacked("valido"))) {
            registro.valido = parseBool(valor);
        }

        emit RegistroAtualizado(profissional, campo, valor);
    }

    function consultarRegistro(address profissional) public view onlyOwner returns (string memory nome, string[] memory documentos, bool temporario, bool valido) {
        Registro storage registro = registros[profissional];
        return (registro.nome, registro.documentos, registro.temporario, registro.valido);
    }

    function gerenciarRegistroTemporario(address profissional, bool status) public onlyOwner {
        registros[profissional].temporario = status;
        emit RegistroTemporarioGerenciado(profissional, status);
    }

    function setNivelAcessoRegistro(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[profissional][usuario] = nivel;
        emit NiveisAcessoAtualizados(profissional, usuario, nivel);
    }

    function validarRegistro(address profissional) public {
        Registro storage registro = registros[profissional];
        require(registro.valido, "Registro nao e valido.");
        emit RegistroValido(profissional);
    }

    function verificarStatusRegistro(address profissional) public view returns (bool) {
        return registros[profissional].valido;
    }

    function criarProposta(string memory descricao, address[] memory participantes) public onlyOwner {
        numPropostas++;
        propostas[numPropostas] = Proposta({
            descricao: descricao,
            participantes: participantes,
            votosSim: 0,
            votosNao: 0
        });

        emit PropostaCriada(numPropostas, descricao, participantes);
    }

    function votar(uint256 propostaId, bool voto) public {
        Proposta storage proposta = propostas[propostaId];
        require(isParticipante(proposta.participantes, msg.sender), "Voce nao pode votar nesta proposta.");
        require(!votos[propostaId][msg.sender], "Voce ja votou nesta proposta.");

        votos[propostaId][msg.sender] = true;
        if (voto) {
            proposta.votosSim++;
        } else {
            proposta.votosNao++;
        }

        emit PropostaVotada(propostaId, msg.sender, voto);
    }

    function consultarPropostas(uint256 propostaId) public view returns (string memory descricao, address[] memory participantes, uint256 votosSim, uint256 votosNao) {
        Proposta storage proposta = propostas[propostaId];
        return (proposta.descricao, proposta.participantes, proposta.votosSim, proposta.votosNao);
    }

    function obterVotosProposta(uint256 propostaId) public view returns (address[] memory participantes, bool[] memory votosArray) {
        Proposta storage proposta = propostas[propostaId];
        uint256 numParticipantes = proposta.participantes.length;
        votosArray = new bool[](numParticipantes);
        participantes = proposta.participantes;

        for (uint256 i = 0; i < numParticipantes; i++) {
            votosArray[i] = votos[propostaId][participantes[i]];
        }

        return (participantes, votosArray);
    }

    function setNivelAcessoProposta(uint256 propostaId, address usuario, uint8 nivel) public onlyOwner {
    }

    function validarProposta(uint256 propostaId) public view returns (bool) {
        Proposta storage proposta = propostas[propostaId];
        return proposta.votosSim > proposta.votosNao;
    }

    function verificarVoto(address usuario) public view returns (bool) {
        for (uint256 i = 1; i <= numPropostas; i++) {
            if (votos[i][usuario]) {
                return true;
            }
        }
        return false;
    }

    function parseBool(string memory valor) internal pure returns (bool) {
        return (keccak256(abi.encodePacked(valor)) == keccak256(abi.encodePacked("true")));
    }

    function isParticipante(address[] memory participantes, address usuario) internal pure returns (bool) {
        for (uint256 i = 0; i < participantes.length; i++) {
            if (participantes[i] == usuario) {
                return true;
            }
        }
        return false;
    }

    function splitString(string memory str) internal pure returns (string[] memory) {
        string[] memory result = new string[](1);
        result[0] = str;
        return result;
    }
}
