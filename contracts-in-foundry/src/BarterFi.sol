// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BarterFi {
    event ApprovedApplication(uint256 _applicationId);
    event DenyApplication(uint256 _applicationId);
    event LoanFunded(uint256 _loanId);

    enum ApplicationState {
        PENDING,
        APPROVED,
        DENIED
    }
    enum LoanState {
        PENDING,
        COLLATERALIZED,
        DEFAULTED,
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
        LoanState state;
    }

    IERC20 stableCoin;
    mapping(address => bool) public admins;
    mapping(uint256 => Application) public loanApplications;
    mapping(uint256 => Loan) public loans;
    mapping(uint256 => bool) public approvedApplications;
    uint256 private appId;
    uint256 private loanId;

    constructor(IERC20 coin) {
        admins[msg.sender] = true;
        stableCoin = coin;
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
        uint256 _collateral
    ) public {
        require(
            admins[msg.sender] == true,
            "Only admins can approve applications"
        );
        approvedApplications[_applicationId] = true;
        emit ApprovedApplication(_applicationId);

        Loan memory loan = Loan({
            applicationId: _applicationId,
            barrower: loanApplications[_applicationId].barrower,
            amount: loanApplications[_applicationId].requestedAmount,
            interestRate: _interestRate,
            collateral: _collateral
        });

        loans[loanId] = loan;
        approvedApplications[_applicationId] = true;
        emit ApprovedApplication(_applicationId);
        loanApplications[_applicationId].state = ApplicationState.APPROVED;
        loanApplications[_applicationId].loanId = loanId;

        loanId += 1;
    }

    function rejectApplication(uint256 _applicationId) public {
        require(
            admins[msg.sender] == true,
            "Only admins can approve applications"
        );

        emit DenyApplication(_applicationId);
        loanApplications[_applicationId].state = ApplicationState.DENIED;
    }

    function provideCollateral(
        uint256 _applicationId
    ) public payable returns (uint256) {
        require(
            approvedApplications[_applicationId] == true,
            "Application must be approved"
        );
        uint256 _loanId = loanApplications[_applicationId].loanId;
        require(
            loans[_loanId].collateral <= msg.value,
            "Must provide correct collateral amount"
        );
        loans[_loanId].state = LoanState.COLLATERALIZED;
        stableCoin.transferFrom(
            address(this),
            msg.sender,
            loans[_loanId].amount
        );
    }
}
