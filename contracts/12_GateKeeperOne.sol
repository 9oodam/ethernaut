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
    // 뒤 2 bytes(16 bits)는 uint16(tx.origin)
    // 중간 2 bytes는 동일한 값 (uint32 == uint16)
    // 상위 4 bytes는 0이 아닌 어떤 값 (그래야 uint32 != uint64)
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