// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SafeMath.sol";

contract Pagamento is Ownable {
    using SafeMath for uint256;

    struct Transacao {
        address destinatario;
        uint256 valor;
        uint256 data;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => Transacao[]) private transacoes;
    mapping(address => uint8) private niveisAcesso;
    mapping(address => string[]) private historico;

    event PagamentoProcessado(address indexed profissional, address indexed destinatario, uint256 valor, uint256 data);
    event NivelAcessoAtualizado(address indexed usuario, uint8 nivel);
    event HistoricoVerificado(address indexed profissional, string[] historico);

    modifier somenteComAcesso() {
        require(niveisAcesso[msg.sender] > 0, "Voce nao tem acesso a esta funcao.");
        _;
    }

    function processarPagamento(address destinatario, uint256 valor) public payable {
        require(destinatario != address(0), "Endereco destinatario invalido.");
        require(valor > 0, "Valor deve ser maior que zero.");
        require(msg.value == valor, "O valor enviado deve ser igual ao valor da transacao.");

        Transacao memory novaTransacao = Transacao({
            destinatario: destinatario,
            valor: valor,
            data: block.timestamp
        });

        transacoes[msg.sender].push(novaTransacao);
        payable(destinatario).transfer(valor);

        emit PagamentoProcessado(msg.sender, destinatario, valor, block.timestamp);
        emitirEventoPagamento("Pagamento processado", destinatario);
    }

    function consultarTransacoes(address profissional) public view somenteComAcesso returns (Transacao[] memory) {
        return transacoes[profissional];
    }

    function setNivelAcessoPagamento(address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[usuario] = nivel;
        emit NivelAcessoAtualizado(usuario, nivel);
    }

    function validarTransacao(address destinatario, uint256 valor) public pure returns (bool) {
        return destinatario != address(0) && valor > 0;
    }

    function consultarHistoricoPagamentos(address profissional) public view somenteComAcesso returns (string[] memory) {
        return historico[profissional];
    }

    function emitirEventoPagamento(string memory evento, address destinatario) internal {
        historico[destinatario].push(evento);
        emit HistoricoVerificado(destinatario, historico[destinatario]);
    }
}
