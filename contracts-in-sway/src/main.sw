contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::{Administrators, Application, ApplicationState, Loan};
use interface::{BarterFi, NativeAssetToken};
use errors::{AccessControlError, InitError};
use events::{ApplicationStatusEvent, LoanStatusEvent};

use std::call_frames::contract_id;
use std::{context::*, logging::log, token::*};
use std::auth::{msg_sender};
use std::storage::StorageVec;
use std::{contract_id::ContractId, identity::Identity};

storage {
    initialized: bool = false,
    admins: StorageMap<Identity, bool> = StorageMap {},
    application_id: u64 = 0,
    loan_applications: StorageMap<u64, Application> = StorageMap {},
    approved_applications: StorageVec<u64> = StorageVec {},
    loan_id: u64 = 0,
    loans: StorageMap<u64, Loan> = StorageMap {},
}

impl BarterFi for Contract {
    #[storage(read, write)]
    fn initialize() -> Identity {
        require(storage.initialized == false, InitError::CannotReinitialize);
        storage.initialized = true;
        let sender = msg_sender().unwrap();
        storage.admins.insert(msg_sender().unwrap(), true);
        (sender)
    }
    #[storage(read)]
    fn check_admin(user: Identity) -> bool {
        let isAdmin = storage.admins.get(user).unwrap();
        isAdmin
    }

    #[storage(read)]
    fn check_application(application_id: u64) -> Application {
        let application = storage.loan_applications.get(application_id).unwrap();
        application
    }

    #[storage(read, write)]
    fn apply_for_loan(barrower: Identity, requested_amount: u64, credit_score: u16) -> u64 {
        let application = Application::new(barrower, requested_amount, credit_score);
        let id = storage.application_id;
        storage.loan_applications.insert(id, application);
        storage.application_id += 1;
        id
    }

    #[storage(read, write)]
    fn approve_loan(application_id: u64, interest_rate: u8, collateral: u64) {
        require(storage.admins.get(msg_sender().unwrap()).unwrap() == true, AccessControlError::OnlyAdminsCanAccess);
        storage.approved_applications.push(application_id);
        log(ApplicationStatusEvent::ApplicationApproved);

        let application: Application = storage.loan_applications.get(application_id).unwrap();
        let loan = Loan::new(application_id, application.barrower, application.requested_amount, interest_rate, collateral);

        let mut updateApplication: Application = storage.loan_applications.get(application_id).unwrap();
        updateApplication.loan_id = Option::Some(storage.loan_id);
        storage.loan_applications.insert(application_id, updateApplication); // Application{ ..updateApplication});
        storage.loans.insert(storage.loan_id, loan);
        storage.loan_id += 1;
    }

    // #[storage(read, write), payable]
    // fn provide_colateral(application_id: u64) {
    //     //require application approved
    //     let application: Application = storage.loan_applications.get(application_id);
    //     require(application.state == ApplicationState::Approved, AccessControlError::ApplicationNotApproved);
    //     require(loans.get(application.loan_id).collateral == msg_amount(), LoanErrors::CollateralRequirementsUnmet);
    //     // transfer() collateral 
    //     // transfer(msg_amount(),,contract_id())
    //     // log collateralized event
    //     // Fund loan to user
    // }
    // #[storage(read, write)]
    // fn fund_loan(
        
    // ) {
    //     log(LoanStatusEvent::LoanFunded);
    // };
}

impl NativeAssetToken for Contract {
    /// Mint an amount of this contracts native asset to the contracts balance.
    #[storage(read, write)]
    fn mint_coins(mint_amount: u64) {
        mint(mint_amount);
    }

    /// Burn an amount of this contracts native asset.
    #[storage(read, write)]
    fn burn_coins(burn_amount: u64) {
        burn(burn_amount);
    }

    /// Transfer coins to a target contract.
    #[storage(read, write)]
    fn force_transfer_coins(coins: u64, asset_id: ContractId, target: ContractId) {
        force_transfer_to_contract(coins, asset_id, target);
    }

    /// Transfer coins to a transaction output to be spent later.
    #[storage(read, write)]
    fn transfer_coins_to_output(coins: u64, asset_id: ContractId, recipient: Address) {
        transfer_to_address(coins, asset_id, recipient);
    }

    /// Get the internal balance of a specific coin at a specific contract.
    #[storage(read, write)]
    fn get_balance(target: ContractId, asset_id: ContractId) -> u64 {
        balance_of(target, asset_id)
    }

    /// Deposit tokens back into the contract.
    #[storage(read, write)]
    fn deposit() {
        assert(msg_amount() > 0);
    }

    /// Mint and send this contracts native token to a destination contract.
    #[storage(read, write)]
    fn mint_and_send_to_contract(amount: u64, destination: ContractId) {
        mint_to_contract(amount, destination);
    }

    /// Mint and send this contracts native token to a destination address.
    #[storage(read, write)]
    fn mint_and_send_to_address(amount: u64, recipient: Address) {
        mint_to_address(amount, recipient);
    }
}
