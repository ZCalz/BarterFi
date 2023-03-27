// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract BarterFi {
    event ApprovedApplication(uint256 applicationId);
    enum ApplicationState {
        PENDING,
        APPROVED,
        DENIED
    }
    enum LoanState {
        PENDING,
        COLLATERALIZED,
        FUNDED,
        REPAID
    }
    struct Application {
        address barrower;
        uint256 requestedAmount;
        uint16 creditScore;
        ApplicationState state;
        uint256 loanId;
    }
    struct Loan {
        uint256 applicationId;
        address barrower;
        uint256 amount;
        uint8 interestRate;
        uint256 collateral;
    }
    mapping(address => bool) public admins;
    mapping(uint256 => Application) public loanApplications;
    mapping(uint256 => Loan) public loans;
    mapping(uint256 => bool) public approvedApplications;
    uint256 private appId;
    uint256 private loanId;

    constructor() {
        admins[msg.sender] = true;
    }

    function applyForLoan(
        uint256 _requestedAmount,
        uint16 _creditScore
    ) public returns (uint256) {
        Application memory app;
        app.barrower = msg.sender;
        app.requestedAmount = _requestedAmount;
        app.creditScore = _creditScore;

        uint256 _loanId = loanId;
        app.loanId = _loanId;

        loanApplications[_loanId] = app;

        loanId += 1;
        return _loanId;
    }

    function approveApplication(
        uint256 _applicationId,
        uint8 _interestRate,
        uint256 collateral
    ) public {
        require(
            admins[msg.sender] == true,
            "Only admins can approve applications"
        );
        approvedApplications[_applicationId] = true;
        emit ApprovedApplication(_applicationId);

        Loan memory loan;
    }

    function provideCollateral() public {}
}
