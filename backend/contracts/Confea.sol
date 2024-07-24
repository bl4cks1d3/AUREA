// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Counters.sol";

contract CONFEA is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _propostaIdCounter;

    struct Proposta {
        string descricao;
        address[] participantes;
        uint256 dataCriacao;
        uint256 votosSim;
        uint256 votosNao;
        bool finalizada;
    }
    constructor() Ownable(msg.sender) {}
    mapping(uint256 => Proposta) private propostas;
    mapping(uint256 => mapping(address => bool)) private votos;
    mapping(uint256 => mapping(address => uint8)) private niveisAcesso;

    event PropostaCriada(uint256 propostaId, string descricao, address[] participantes);
    event VotoRegistrado(uint256 propostaId, address usuario, bool voto);
    event PropostaFinalizada(uint256 propostaId, uint256 votosSim, uint256 votosNao);
    event NiveisAcessoAtualizados(uint256 propostaId, address usuario, uint8 nivel);

    modifier somenteParticipantes(uint256 propostaId) {
        bool isParticipante = false;
        for (uint i = 0; i < propostas[propostaId].participantes.length; i++) {
            if (propostas[propostaId].participantes[i] == msg.sender) {
                isParticipante = true;
                break;
            }
        }
        require(isParticipante, "Voce nao e participante desta proposta.");
        _;
    }

    function criarProposta(string memory descricao, address[] memory participantes) public onlyOwner {
        uint256 propostaId = _propostaIdCounter.current();
        _propostaIdCounter.increment();

        Proposta storage novaProposta = propostas[propostaId];
        novaProposta.descricao = descricao;
        novaProposta.participantes = participantes;
        novaProposta.dataCriacao = block.timestamp;

        emit PropostaCriada(propostaId, descricao, participantes);
    }

    function votar(uint256 propostaId, bool voto) public somenteParticipantes(propostaId) {
        require(!propostas[propostaId].finalizada, "A proposta ja foi finalizada.");
        require(!votos[propostaId][msg.sender], "Voce ja votou nesta proposta.");

        if (voto) {
            propostas[propostaId].votosSim++;
        } else {
            propostas[propostaId].votosNao++;
        }
        votos[propostaId][msg.sender] = true;

        emit VotoRegistrado(propostaId, msg.sender, voto);
    }

    function consultarPropostas(uint256 propostaId) public view returns (string memory descricao, address[] memory participantes, uint256 dataCriacao, uint256 votosSim, uint256 votosNao, bool finalizada) {
        Proposta storage p = propostas[propostaId];
        return (p.descricao, p.participantes, p.dataCriacao, p.votosSim, p.votosNao, p.finalizada);
    }

    function consultarVotos(uint256 propostaId) public view returns (uint256 votosSim, uint256 votosNao) {
        Proposta storage p = propostas[propostaId];
        return (p.votosSim, p.votosNao);
    }

    function finalizarProposta(uint256 propostaId) public onlyOwner {
        require(!propostas[propostaId].finalizada, "A proposta ja foi finalizada.");
        Proposta storage p = propostas[propostaId];
        p.finalizada = true;
        
        emit PropostaFinalizada(propostaId, p.votosSim, p.votosNao);
    }

    function setNivelAcessoProposta(uint256 propostaId, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[propostaId][usuario] = nivel;
        emit NiveisAcessoAtualizados(propostaId, usuario, nivel);
    }

    function validarProposta(uint256 propostaId) public view returns (bool) {
        return propostas[propostaId].dataCriacao > 0 && !propostas[propostaId].finalizada;
    }

    function verificarVoto(address usuario, uint256 propostaId) public view returns (bool) {
        return votos[propostaId][usuario];
    }
}
