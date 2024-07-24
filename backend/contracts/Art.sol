// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ART is Ownable {
    struct Art {
        string descricao;
        uint256 data;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => Art[]) private arts;
    mapping(address => uint8) private niveisAcesso;
    mapping(address => string[]) private historico;

    event ArtAdicionada(address indexed profissional, string descricao, uint256 data);
    event NivelAcessoAtualizado(address indexed profissional, address indexed usuario, uint8 nivel);
    event HistoricoARTConsultado(address indexed profissional, string[] historico);

    modifier somenteComAcesso() {
        require(niveisAcesso[msg.sender] > 0, "Voce nao tem acesso a esta funcao.");
        _;
    }

    function adicionarART(address profissional, string memory descricao, uint256 data) public onlyOwner {
        Art memory novaArt = Art({
            descricao: descricao,
            data: data
        });

        arts[profissional].push(novaArt);

        emitirEventoART("ART adicionada", profissional);
        emit ArtAdicionada(profissional, descricao, data);
    }

    function consultarART(address profissional) public view somenteComAcesso returns (Art[] memory) {
        return arts[profissional];
    }

    function setNivelAcessoART(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[usuario] = nivel;
        emit NivelAcessoAtualizado(profissional, usuario, nivel);
    }

    function validarART(address profissional, string memory descricao) public view returns (bool) {
        for (uint256 i = 0; i < arts[profissional].length; i++) {
            if (keccak256(bytes(arts[profissional][i].descricao)) == keccak256(bytes(descricao))) {
                return true;
            }
        }
        return false;
    }

    function consultarHistoricoART(address profissional) public view somenteComAcesso returns (string[] memory) {
        return historico[profissional];
    }

    function emitirEventoART(string memory evento, address profissional) internal {
        historico[profissional].push(evento);
        emit HistoricoARTConsultado(profissional, historico[profissional]);
    }
}
