// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BarterFi.sol";
import "../src/MockStableCoin.sol";

contract BarterFiTest is Test {
    BarterFi barterFi;
    IERC20 mockUSD;
    address alice = address(0xA);
    address bob = address(0xB);

    function setUp() public {
        mockUSD = new MockStableCoin("Mock USD", "MUSD");
        barterFi = new BarterFi(mockUSD);
        vm.deal(bob, 100 ether);
        vm.deal(alice, 100 ether);
        mockUSD.transfer(address(barterFi), 100 ether);
    }

    function test_ApplyForLoan() public {
        uint256 requestedAmount = 10_000;
        uint16 creditScore = 760;
        vm.prank(bob);

        uint256 applicationId = barterFi.applyForLoan(
            requestedAmount,
            creditScore
        );
        BarterFi.Application memory application = barterFi.getLoanApplication(
            applicationId
        );

        assertEq(application.requestedAmount, requestedAmount);
        assertEq(application.creditScore, creditScore);
        assertEq(application.barrower, bob);
        assertEq(application.loanId, 0);
        assertEq(
            uint8(application.state),
            uint8(BarterFi.ApplicationState.PENDING)
        );
    }

    function test_ApplyForAnotherLoan() public {
        test_ApplyForLoan();
        test_ApplyForLoan();
        test_ApplyForLoan();
        test_ApplyForLoan();
        uint256 requestedAmount = 5_000;
        uint16 creditScore = 790;
        vm.prank(alice);

        uint256 applicationId = barterFi.applyForLoan(
            requestedAmount,
            creditScore
        );
        BarterFi.Application memory application = barterFi.getLoanApplication(
            applicationId
        );

        assertEq(application.requestedAmount, requestedAmount);
        assertEq(application.creditScore, creditScore);
        assertEq(application.barrower, alice);
        assertEq(application.loanId, 0);
        assertEq(
            uint8(application.state),
            uint8(BarterFi.ApplicationState.PENDING)
        );
    }

    function test_ApproveApplication() public {
        uint256 applicationId = 0;
        uint8 interestRate = 2;
        uint256 collateral = 5 ether;
        test_ApplyForLoan();
        BarterFi.Application memory application = barterFi.getLoanApplication(
            applicationId
        );
        assertEq(application.creditScore, 760);
        assertEq(application.barrower, bob);

        barterFi.approveApplication(applicationId, interestRate, collateral);
        assertTrue(true);
    }

    function test_RevertWhenApproveApplication() public {
        uint256 applicationId = 0;
        uint8 interestRate = 2;
        uint256 collateral = 5 ether;
        vm.expectRevert("Requires acceptable credit score");
        barterFi.approveApplication(applicationId, interestRate, collateral);

        test_ApplyForLoan();
        BarterFi.Application memory application = barterFi.getLoanApplication(
            applicationId
        );
        assertEq(application.creditScore, 760);

        vm.prank(bob);
        vm.expectRevert("Only admins can approve applications");
        barterFi.approveApplication(applicationId, interestRate, collateral);

        vm.prank(alice);
        vm.expectRevert("Only admins can approve applications");
        barterFi.approveApplication(applicationId, interestRate, collateral);
    }

    function test_RejectApplication() public {
        uint256 applicationId = 0;
        test_ApplyForLoan();
        BarterFi.Application memory application = barterFi.getLoanApplication(
            applicationId
        );
        assertEq(application.creditScore, 760);
        assertEq(
            uint8(application.state),
            uint8(BarterFi.ApplicationState.PENDING)
        );
        barterFi.rejectApplication(applicationId);
        application = barterFi.getLoanApplication(applicationId);
        assertEq(
            uint8(application.state),
            uint8(BarterFi.ApplicationState.DENIED)
        );
    }

    function test_ReventRejectApplication() public {
        uint256 applicationId = 0;
        test_ApplyForLoan();
        vm.prank(bob);
        vm.expectRevert("Only admins can approve applications");
        barterFi.rejectApplication(applicationId);
    }

    function testProvideCollateral() public {
        uint256 applicationId = 0;
        test_ApproveApplication();
        uint256 balanceOfBob = mockUSD.balanceOf(bob);
        assertEq(balanceOfBob, 0);

        vm.prank(bob);
        barterFi.provideCollateral{value: 5 ether}(applicationId);

        BarterFi.Application memory application = barterFi.getLoanApplication(
            applicationId
        );
        uint256 loanId = application.loanId;

        BarterFi.Loan memory loan = barterFi.getLoanDetails(loanId);

        assertEq(loan.applicationId, applicationId);
        assertEq(loan.barrower, application.barrower);
        assertEq(loan.amount, application.requestedAmount);
        assertEq(loan.interestRate, 2);
        assertEq(loan.collateral, 5 ether);
        assertEq(uint8(loan.state), uint8(BarterFi.LoanState.COLLATERALIZED));

        balanceOfBob = mockUSD.balanceOf(bob);

        assertEq(balanceOfBob, loan.amount);
    }

    function test_RevertWhenUnderCollateralized() public {
        uint256 applicationId = 0;
        test_ApproveApplication();

        vm.prank(bob);
        vm.expectRevert("Must provide correct collateral amount");
        barterFi.provideCollateral{value: 4 ether}(applicationId);
    }
}
