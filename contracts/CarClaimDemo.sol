// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CarClaimDemo {
    address public insurer;
    uint256 public nextClaimId;

    enum ClaimStatus { None, Submitted, OracleChecked, Approved, Denied }

    struct Claim {
        string claimantName;
        string policyNumber;
        string evidenceHash;
        address recipientWallet;
        uint256 payoutAmount;
        uint8 damageConfidence;
        bool flaggedFraud;
        ClaimStatus status;
    }

    mapping(uint256 => Claim) public claims;

    constructor() {
        insurer = msg.sender;

        // Hardcoded claims
        claims[0] = Claim({
            claimantName:    "Alice",
            policyNumber:    "CAR-001",
            evidenceHash:    "Qm1...",
            recipientWallet: 0x1234567890123456789012345678901234567890,
            payoutAmount:    2 ether,
            damageConfidence: 90,
            flaggedFraud:    false,
            status:          ClaimStatus.Approved
        });

        claims[1] = Claim({
            claimantName:    "Bob",
            policyNumber:    "CAR-002",
            evidenceHash:    "Qm2...",
            recipientWallet: 0x7890123456789012345678901234567890123454,
            payoutAmount:    1 ether,
            damageConfidence: 65,
            flaggedFraud:    false,
            status:          ClaimStatus.OracleChecked
        });

        claims[2] = Claim({
            claimantName:    "Carol",
            policyNumber:    "CAR-003",
            evidenceHash:    "Qm3...",
            recipientWallet: 0x7890123456789012345678901234567890123456,
            payoutAmount:    0,
            damageConfidence: 0,
            flaggedFraud:    true,
            status:          ClaimStatus.Denied
        });

        nextClaimId = 3;
    }

    function getClaim(uint256 id) public view returns (Claim memory) {
        return claims[id];
    }

    function updateStatus(uint256 claimId, ClaimStatus newStatus) external {
        require(msg.sender == insurer, "Only insurer can update status");
        claims[claimId].status = newStatus;
    }

    function payoutClaim(uint256 claimId) external {
        require(msg.sender == insurer, "Only insurer can payout");
        Claim storage claim = claims[claimId];
        require(claim.status == ClaimStatus.Approved, "Claim not approved");
        require(claim.payoutAmount > 0, "No payout set");

        payable(claim.recipientWallet).transfer(claim.payoutAmount);
        claim.payoutAmount = 0; // prevent double payout
    }

    // To receive funds into the contract for demo
    receive() external payable {}
}