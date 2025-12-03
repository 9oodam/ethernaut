// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin); // 컨트랙트를 통해 호출해야 함
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller()) // caller() : msg.sender (attack 의 주소)
        }
        require(x == 0); // 정상적으로 배포된 컨트랙트면 extcodesize 가 0 이 아님
        _;
    } // 하지만 솔리디티에서 constructor 실행 중이면 extcodesize 가 0 이 된다고 함 => enter() 를 constructor 내부에서 실행해야 함


    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}