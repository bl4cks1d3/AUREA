// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Titulo is Ownable {
    struct TituloInfo {
        string titulo;
        string descricao;
        uint256 dataEmissao;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => TituloInfo[]) private titulos;
    mapping(address => mapping(address => uint8)) private niveisAcesso;
    mapping(address => string[]) private historico;

    event TituloAdicionado(address indexed profissional, string titulo, string descricao, uint256 dataEmissao);
    event TituloRemovido(address indexed profissional, string titulo);
    event NivelAcessoAtualizado(address indexed profissional, address indexed usuario, uint8 nivel);
    event HistoricoVerificado(address indexed profissional, string[] historico);

    modifier somenteComAcesso(address profissional) {
        require(niveisAcesso[profissional][msg.sender] > 0, "Voce nao tem acesso ao registro deste profissional.");
        _;
    }

    function adicionarTitulo(address profissional, string memory titulo, string memory descricao, uint256 dataEmissao) public onlyOwner {
        TituloInfo memory novoTitulo = TituloInfo({titulo: titulo, descricao: descricao, dataEmissao: dataEmissao});
        titulos[profissional].push(novoTitulo);
        emit TituloAdicionado(profissional, titulo, descricao, dataEmissao);
        emitirEventoTitulo("Titulo adicionado", profissional);
    }

    function consultarTitulos(address profissional) public view somenteComAcesso(profissional) returns (TituloInfo[] memory) {
        return titulos[profissional];
    }

    function removerTitulo(address profissional, string memory titulo) public onlyOwner {
        TituloInfo[] storage titulosProfissional = titulos[profissional];
        for (uint256 i = 0; i < titulosProfissional.length; i++) {
            if (keccak256(bytes(titulosProfissional[i].titulo)) == keccak256(bytes(titulo))) {
                titulosProfissional[i] = titulosProfissional[titulosProfissional.length - 1];
                titulosProfissional.pop();
                emit TituloRemovido(profissional, titulo);
                emitirEventoTitulo("Titulo removido", profissional);
                break;
            }
        }
    }

    function setNivelAcessoTitulo(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[profissional][usuario] = nivel;
        emit NivelAcessoAtualizado(profissional, usuario, nivel);
    }

    function validarTitulo(address profissional, string memory titulo) public view somenteComAcesso(profissional) returns (bool) {
        TituloInfo[] storage titulosProfissional = titulos[profissional];
        for (uint256 i = 0; i < titulosProfissional.length; i++) {
            if (keccak256(bytes(titulosProfissional[i].titulo)) == keccak256(bytes(titulo))) {
                return true;
            }
        }
        return false;
    }

    function consultarHistoricoTitulos(address profissional) public view somenteComAcesso(profissional) returns (string[] memory) {
        return historico[profissional];
    }

    function emitirEventoTitulo(string memory evento, address profissional) internal {
        historico[profissional].push(evento);
        emit HistoricoVerificado(profissional, historico[profissional]);
    }
}
