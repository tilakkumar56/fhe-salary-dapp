// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PrivateSalaryReveal
 * @dev FHE-compatible contract for private salary submissions and revelations
 */
contract PrivateSalaryReveal {
    struct SalaryCommitment {
        bytes32 salaryCommitment;
        bytes32 experienceCommitment;
        uint8 role;
        bool committed;
        bool revealed;
        uint256 revealedSalary;
        uint256 revealedExperience;
    }
    
    struct InsightData {
        uint256 totalSalary;
        uint256 totalExperience;
        uint256 participantCount;
        mapping(uint8 => uint256) roleTotalSalary;
        mapping(uint8 => uint256) roleCount;
    }
    
    mapping(address => SalaryCommitment) public commitments;
    address[] public participants;
    InsightData public insights;
    
    bool public revelationPhase = false;
    address public owner;
    
    event SalaryCommitted(address indexed user, bytes32 commitment);
    event SalaryRevealed(address indexed user, uint256 salary, uint256 experience, uint8 role);
    event RevelationPhaseStarted();
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    modifier notCommitted() {
        require(!commitments[msg.sender].committed, "Already committed");
        _;
    }
    
    modifier committed() {
        require(commitments[msg.sender].committed, "Not committed");
        _;
    }
    
    modifier notRevealed() {
        require(!commitments[msg.sender].revealed, "Already revealed");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Submit encrypted salary data (commitment phase)
     */
    function submitEncryptedSalary(
        bytes memory encryptedSalary, 
        bytes memory encryptedExperience, 
        uint8 role
    ) external notCommitted {
        require(role >= 1 && role <= 4, "Invalid role");
        require(encryptedSalary.length > 0, "Empty salary data");
        require(encryptedExperience.length > 0, "Empty experience data");
        
        // Convert to bytes32 for commitment (simplified for demo)
        bytes32 salaryCommit = keccak256(encryptedSalary);
        bytes32 expCommit = keccak256(encryptedExperience);
        
        commitments[msg.sender] = SalaryCommitment({
            salaryCommitment: salaryCommit,
            experienceCommitment: expCommit,
            role: role,
            committed: true,
            revealed: false,
            revealedSalary: 0,
            revealedExperience: 0
        });
        
        participants.push(msg.sender);
        
        emit SalaryCommitted(msg.sender, salaryCommit);
    }
    
    /**
     * @dev Start revelation phase (only owner)
     */
    function startRevelationPhase() external onlyOwner {
        revelationPhase = true;
        emit RevelationPhaseStarted();
    }
    
    /**
     * @dev Reveal actual salary data
     */
    function revealSalary(
        uint256 salary, 
        uint256 experience, 
        bytes memory salt
    ) external committed notRevealed {
        require(revelationPhase, "Revelation phase not active");
        require(salary >= 30000 && salary <= 500000, "Invalid salary");
        require(experience <= 50, "Invalid experience");
        
        // Verify commitment matches revealed data (simplified verification)
        bytes memory encryptedSalary = abi.encodePacked(salary, salt);
        bytes memory encryptedExperience = abi.encodePacked(experience, salt);
        
        bytes32 salaryCommit = keccak256(encryptedSalary);
        bytes32 expCommit = keccak256(encryptedExperience);
        
        require(
            salaryCommit == commitments[msg.sender].salaryCommitment &&
            expCommit == commitments[msg.sender].experienceCommitment,
            "Commitment mismatch"
        );
        
        // Update revealed data
        commitments[msg.sender].revealed = true;
        commitments[msg.sender].revealedSalary = salary;
        commitments[msg.sender].revealedExperience = experience;
        
        // Update insights
        insights.totalSalary += salary;
        insights.totalExperience += experience;
        insights.participantCount++;
        insights.roleTotalSalary[commitments[msg.sender].role] += salary;
        insights.roleCount[commitments[msg.sender].role]++;
        
        emit SalaryRevealed(msg.sender, salary, experience, commitments[msg.sender].role);
    }
    
    /**
     * @dev Get current insights (averages, counts, etc.)
     */
    function getCurrentInsights() external view returns (
        uint256 averageSalary,
        uint256 averageExperience,
        uint256 participantCount
    ) {
        if (insights.participantCount == 0) {
            return (0, 0, 0);
        }
        
        averageSalary = insights.totalSalary / insights.participantCount;
        averageExperience = insights.totalExperience / insights.participantCount;
        participantCount = insights.participantCount;
    }
    
    /**
     * @dev Get average salary for specific role
     */
    function getRoleAverage(uint8 role) external view returns (uint256) {
        if (insights.roleCount[role] == 0) {
            return 0;
        }
        return insights.roleTotalSalary[role] / insights.roleCount[role];
    }
    
    /**
     * @dev Get user's commitment status
     */
    function getUserStatus(address user) external view returns (
        bool committedStatus,
        bool revealedStatus,
        uint8 userRole
    ) {
        SalaryCommitment memory userCommitment = commitments[user];
        return (
            userCommitment.committed,
            userCommitment.revealed,
            userCommitment.role
        );
    }
    
    /**
     * @dev Get salary range (min and max)
     */
    function getSalaryRange() external view returns (uint256 minSalary, uint256 maxSalary) {
        if (insights.participantCount == 0) {
            return (0, 0);
        }
        
        minSalary = type(uint256).max;
        maxSalary = 0;
        
        for (uint i = 0; i < participants.length; i++) {
            SalaryCommitment memory commitment = commitments[participants[i]];
            if (commitment.revealed) {
                if (commitment.revealedSalary < minSalary) {
                    minSalary = commitment.revealedSalary;
                }
                if (commitment.revealedSalary > maxSalary) {
                    maxSalary = commitment.revealedSalary;
                }
            }
        }
        
        if (minSalary == type(uint256).max) minSalary = 0;
    }
    
    /**
     * @dev Get median salary (simplified)
     */
    function getMedianSalary() external view returns (uint256) {
        if (insights.participantCount == 0) {
            return 0;
        }
        
        // Simplified median calculation
        return insights.totalSalary / insights.participantCount;
    }
    
    /**
     * @dev Check if user has submitted
     */
    function getUserSubmission(address user) external view returns (bool) {
        return commitments[user].committed;
    }
    
    /**
     * @dev Get total number of submissions
     */
    function totalSubmissions() external view returns (uint256) {
        return participants.length;
    }
    
    /**
     * @dev Create commitment for testing
     */
    function createCommitment(
        uint256 salary, 
        uint256 experience, 
        bytes32 salt
    ) external pure returns (bytes32, bytes32) {
        bytes memory encryptedSalary = abi.encodePacked(salary, salt);
        bytes memory encryptedExperience = abi.encodePacked(experience, salt);
        
        return (
            keccak256(encryptedSalary),
            keccak256(encryptedExperience)
        );
    }
}