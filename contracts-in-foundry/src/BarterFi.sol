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

        uint256 _appId = appId;
        appId += 1;

        loanApplications[_appId] = app;

        return _appId;
    }

    function getLoanApplication(
        uint256 applicationId
    ) public view returns (Application memory) {
        return loanApplications[applicationId];
    }

    function getLoanDetails(uint256 _loanId) public view returns (Loan memory) {
        return loans[_loanId];
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
        Application memory application = getLoanApplication(_applicationId);
        require(
            application.creditScore > 0,
            "Requires acceptable credit score"
        );

        approvedApplications[_applicationId] = true;
        emit ApprovedApplication(_applicationId);

        Loan memory loan = Loan({
            applicationId: _applicationId,
            barrower: loanApplications[_applicationId].barrower,
            amount: loanApplications[_applicationId].requestedAmount,
            interestRate: _interestRate,
            collateral: _collateral,
            state: LoanState.PENDING
        });

        loanId += 1;
        loans[loanId] = loan;
        approvedApplications[_applicationId] = true;
        emit ApprovedApplication(_applicationId);
        loanApplications[_applicationId].state = ApplicationState.APPROVED;
        loanApplications[_applicationId].loanId = loanId;
    }

    function rejectApplication(uint256 _applicationId) public {
        require(
            admins[msg.sender] == true,
            "Only admins can approve applications"
        );

        loanApplications[_applicationId].state = ApplicationState.DENIED;
        emit DenyApplication(_applicationId);
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
        stableCoin.transfer(msg.sender, loans[_loanId].amount);
        return _loanId;
    }
}
