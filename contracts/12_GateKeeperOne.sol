// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin); // 컨트랙트를 통해 호출해야 함
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0); // 남은 gas가 8191의 배수여야 함. 반복 시도해서 맞는 gas를 찾아야 함
        _;
    }

    // _gateKey 의 구조 (ex. 0x????????0000XXXX)
    // 0x ???? ???? 0000 XXXX
    // 1. uint64(_gateKey)의 하위 32비트 == 하위 16비트
    // 2. 하위 32비트 != 전체 64비트 / 상위 32비트가 0이 아니어야 함
    // 3. _gateKey 의 하위 16비트 == tx.origin 의 하위 16비트
    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}