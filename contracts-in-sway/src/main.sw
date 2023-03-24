contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::{Application,Loan,State, Administrators};
use interface::{Barterfi};
use errors::{InitError, AccessControlError};
use events::{ApplicationStatusEvent, LoanStatusEvent};

storage {
    initialized: bool = false;
    admins: StorageMap<Identity, bool> = StorageMap {};

    application_id: u64 = 0,
    loan_applications: StorageMap<u64, LoanApplication> = StorageMap {},

    approved_applications: StorageVec<u64> = StorageVec {},

    loan_id: u64 = 0,
    loans_funded: StorageMap<u64, Loan> = StorageMap {},
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

        storage.loans_funded.insert(storage.loan_id,loan);
        storage.loan_id += 1;
    };

    #[storage(read, write, payable)]
    fn provide_colateral(application_id: u64){
        //require application approved
        require(storage.loan_applications.get(application_id).state == ApplicationState::Approved, AccessControlError::ApplicationNotApproved)
        require(storage.loans_funded.get(application_id).state == msg_value())
    };

    #[storage(read, write)]
    fn fund_loan(
        
    ) {
        log(LoanStatusEvent::LoanFunded);
    };
}
