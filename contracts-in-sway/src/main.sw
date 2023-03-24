contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::{Application,Loan,State, Administrators};
use interface::{Barterfi};
use errors::{InitError, AccessControlError};
use events::{ApplicationStatusEvent, LoanStatusEvent};

use std::{context::*, token::*};

storage {
    initialized: bool = false;
    admins: StorageMap<Identity, bool> = StorageMap {};

    application_id: u64 = 0,
    loan_applications: StorageMap<u64, LoanApplication> = StorageMap {},

    approved_applications: StorageVec<u64> = StorageVec {},

    loan_id: u64 = 0,
    loans: StorageMap<u64, Loan> = StorageMap {},
}

impl Barterfi for Contract {
    #[storage(read, write)]
    fn initialize() {
        require(initialized == false, InitError::CannotReinitialize);
        storage.initialized = true;
        admins.insert(msg_sender(),true);
    };

    #[storage(read, write)]
    fn apply_for_loan(
        barrower: Indentity,
        requested_amount: u64,
        credit_score: u16
    ) {
        let application = Application::new(
            barrower,
            requested_amount,
            credit_score
        )
        storage.loan_applications.insert(storage.application_id, application);
        storage.application_id += 1;
    };

    #[storage(read, write)]
    fn approve_loan(application_id:u64, interest_rate: u64, collateral: u64) {
        require(admins.get(msg_sender())==true, AccessControlError::OnlyAdminsCanAccess)
        storage.approved_applications.push(application_id);
        log(ApplicationStatusEvent::ApplicationApproved);

        let application: LoanApplication = storage.loan_applications.get(application_id);
        let loan = Loan::new(
            application_id,
            application.barrower,
            application.amount,
            interest_rate,
            collateral
        );

        let mut updateApplication: LoanApplication = storage.loan_applications.get(application_id);
        updateApplication.loan_id = storage.loan_id;
        loan_applications.insert(application_id, updateApplication);
        storage.loans.insert(storage.loan_id,loan);
        storage.loan_id += 1;
    };

    #[storage(read, write, payable)]
    fn provide_colateral(application_id: u64){
        //require application approved
        let application: LoanApplication = storage.loan_applications.get(application_id);
        require(application.state == ApplicationState::Approved, AccessControlError::ApplicationNotApproved)
        require(loans.get(application.loan_id).collateral == msg_amount(), LoanErrors::CollateralRequirementsUnmet);
        // transfer() collateral 

        // log collateralized event

        // Fund loan to user

    };

    #[storage(read, write)]
    fn fund_loan(
        
    ) {
        log(LoanStatusEvent::LoanFunded);
    };
}

impl NativeAssetToken for Contract {
    /// Mint an amount of this contracts native asset to the contracts balance.
    fn mint_coins(mint_amount: u64) {
        mint(mint_amount);
    }

    /// Burn an amount of this contracts native asset.
    fn burn_coins(burn_amount: u64) {
        burn(burn_amount);
    }

    /// Transfer coins to a target contract.
    fn force_transfer_coins(coins: u64, asset_id: ContractId, target: ContractId) {
        force_transfer_to_contract(coins, asset_id, target);
    }

    /// Transfer coins to a transaction output to be spent later.
    fn transfer_coins_to_output(coins: u64, asset_id: ContractId, recipient: Address) {
        transfer_to_address(coins, asset_id, recipient);
    }

    /// Get the internal balance of a specific coin at a specific contract.
    fn get_balance(target: ContractId, asset_id: ContractId) -> u64 {
        balance_of(target, asset_id)
    }

    /// Deposit tokens back into the contract.
    fn deposit() {
        assert(msg_amount() > 0);
    }

    /// Mint and send this contracts native token to a destination contract.
    fn mint_and_send_to_contract(amount: u64, destination: ContractId) {
        mint_to_contract(amount, destination);
    }

    /// Mind and send this contracts native token to a destination address.
    fn mint_and_send_to_address(amount: u64, recipient: Address) {
        mint_to_address(amount, recipient);
    }
}