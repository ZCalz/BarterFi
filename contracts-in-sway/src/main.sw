contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::{Application,Loan};
use interface::{Barterfi};

storage {
    application_id: u64 = 0,
    loan_applications: StorageMap<u64, LoanApplication> = StorageMap {},

    assets: StorageVec<Asset> = StorageVec {},
    loan_id: u64 = 0,
    loans_funded: StorageMap<u64, bool> = StorageMap {},
}

impl Barterfi for Contract {
    #[storage(read, write)]
    fn apply_for_loan();

    #[storage(read, write)]
    fn approve_loan();

    #[storage(read, write)]
    fn provide_colateral();

    #[storage(read, write)]
    fn fund_loan();

    #[storage(read, write)]
    fn estimate_interest();
}
