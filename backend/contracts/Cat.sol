// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CAT is Ownable {
    struct Cat {
        string descricao;
        uint256 data;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => Cat[]) private cats;
    mapping(address => uint8) private niveisAcesso;
    mapping(address => string[]) private historico;

    event CatAdicionada(address indexed profissional, string descricao, uint256 data);
    event NivelAcessoAtualizado(address indexed profissional, address indexed usuario, uint8 nivel);
    event HistoricoCATConsultado(address indexed profissional, string[] historico);

    modifier somenteComAcesso() {
        require(niveisAcesso[msg.sender] > 0, "Voce nao tem acesso a esta funcao.");
        _;
    }

    function adicionarCAT(address profissional, string memory descricao, uint256 data) public onlyOwner {
        Cat memory novaCat = Cat({
            descricao: descricao,
            data: data
        });

        cats[profissional].push(novaCat);

        emitirEventoCAT("CAT adicionada", profissional);
        emit CatAdicionada(profissional, descricao, data);
    }

    function consultarCAT(address profissional) public view somenteComAcesso returns (Cat[] memory) {
        return cats[profissional];
    }

    function setNivelAcessoCAT(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[usuario] = nivel;
        emit NivelAcessoAtualizado(profissional, usuario, nivel);
    }

    function validarCAT(address profissional, string memory descricao) public view returns (bool) {
        for (uint256 i = 0; i < cats[profissional].length; i++) {
            if (keccak256(bytes(cats[profissional][i].descricao)) == keccak256(bytes(descricao))) {
                return true;
            }
        }
        return false;
    }

    function consultarHistoricoCAT(address profissional) public view somenteComAcesso returns (string[] memory) {
        return historico[profissional];
    }

    function emitirEventoCAT(string memory evento, address profissional) internal {
        historico[profissional].push(evento);
        emit HistoricoCATConsultado(profissional, historico[profissional]);
    }
}
