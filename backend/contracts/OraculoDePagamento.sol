// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract OraculoDePagamento is Ownable {
    struct Consulta {
        string resultado;
        uint256 data;
    }

    mapping(string => Consulta) private consultasBoleto;
    mapping(string => Consulta) private consultasPix;
    mapping(address => uint8) private niveisAcesso;
    mapping(string => string[]) private historico;

    event DadosConsultados(string indexed consulta, string resultado, uint256 data);
    event NivelAcessoAtualizado(address indexed usuario, uint8 nivel);
    event HistoricoDadosConsultados(string indexed consulta, string[] historico);

    constructor() Ownable(msg.sender) {}

    modifier somenteComAcesso() {
        require(niveisAcesso[msg.sender] > 0, "Voce nao tem acesso a esta funcao.");
        _;
    }

    function consultarDadosBoleto(string memory referencia) public view somenteComAcesso returns (string memory) {
        return consultasBoleto[referencia].resultado;
    }

    function consultarDadosPix(string memory chavePix) public view somenteComAcesso returns (string memory) {
        return consultasPix[chavePix].resultado;
    }

    function fornecerDados(string memory referencia, string memory resultado, bool isBoleto) public onlyOwner {
        uint256 dataAtual = block.timestamp;
        Consulta memory novaConsulta = Consulta({
            resultado: resultado,
            data: dataAtual
        });

        if (isBoleto) {
            consultasBoleto[referencia] = novaConsulta;
        } else {
            consultasPix[referencia] = novaConsulta;
        }

        // Emitir evento para rastrear a ação
        emitirEventoOraculo("Dados fornecidos");
        emit DadosConsultados(referencia, resultado, dataAtual);
    }

    function setNivelAcessoOraculo(address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[usuario] = nivel;
        emit NivelAcessoAtualizado(usuario, nivel);
    }

    function validarConsulta(string memory referencia, bool isBoleto) public view returns (bool) {
        if (isBoleto) {
            return bytes(consultasBoleto[referencia].resultado).length > 0;
        } else {
            return bytes(consultasPix[referencia].resultado).length > 0;
        }
    }

    function consultarHistoricoDados(string memory referencia) public view somenteComAcesso returns (string[] memory) {
        return historico[referencia];
    }

    function emitirEventoOraculo(string memory evento) internal {
        historico[evento].push(evento);
        emit HistoricoDadosConsultados(evento, historico[evento]);
    }
}
