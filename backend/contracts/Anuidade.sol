// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Anuidade is Ownable {
    struct AnuidadeInfo {
        uint256 valor;
        uint256 dataPagamento;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => AnuidadeInfo[]) private anuidades;
    mapping(address => mapping(address => uint8)) private niveisAcesso;
    mapping(address => string[]) private historico;

    event AnuidadeAdicionada(address indexed profissional, uint256 valor, uint256 dataPagamento);
    event NivelAcessoAtualizado(address indexed profissional, address indexed usuario, uint8 nivel);
    event HistoricoVerificado(address indexed profissional, string[] historico);

    modifier somenteComAcesso(address profissional) {
        require(niveisAcesso[profissional][msg.sender] > 0, "Voce nao tem acesso ao registro deste profissional.");
        _;
    }

    function adicionarAnuidade(address profissional, uint256 valor, uint256 dataPagamento) public onlyOwner {
        AnuidadeInfo memory novaAnuidade = AnuidadeInfo({valor: valor, dataPagamento: dataPagamento});
        anuidades[profissional].push(novaAnuidade);
        emit AnuidadeAdicionada(profissional, valor, dataPagamento);
        emitirEventoAnuidade("Anuidade adicionada", profissional);
    }

    function consultarAnuidades(address profissional) public view somenteComAcesso(profissional) returns (AnuidadeInfo[] memory) {
        return anuidades[profissional];
    }

    function verificarStatusAnuidade(address profissional) public view somenteComAcesso(profissional) returns (bool) {
        if (anuidades[profissional].length == 0) {
            return false;
        }
        AnuidadeInfo memory ultimaAnuidade = anuidades[profissional][anuidades[profissional].length - 1];
        return (block.timestamp - ultimaAnuidade.dataPagamento) < 365 days;
    }

    function setNivelAcessoAnuidade(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[profissional][usuario] = nivel;
        emit NivelAcessoAtualizado(profissional, usuario, nivel);
    }

    function consultarHistoricoAnuidade(address profissional) public view somenteComAcesso(profissional) returns (string[] memory) {
        return historico[profissional];
    }

    function emitirEventoAnuidade(string memory evento, address profissional) internal {
        historico[profissional].push(evento);
        emit HistoricoVerificado(profissional, historico[profissional]);
    }
}
