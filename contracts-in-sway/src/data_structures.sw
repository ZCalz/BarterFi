library data_structures;

pub struct Barrower {
    address: Identity,
    credit_score: u16,
}

pub struct Administrators {
    address: Identity,
}

pub struct Loan {
    application_id: u64,
    barrower: Indentity,
    amount: u64,
    interest_rate: u64,
    collateral: u64
}

pub struct Application {
    barrower: Indentity,
    requested_amount: u64,
    credit_score: u16
    state: State
}

impl Loan {
    pub fn new(
        application_id: u64,
        barrower: Indentity,
        amount: u64,
        interest_rate: u64,
        collateral: u64
    ) -> Self {
        Self {
            application_id,
            barrower,
            amount,
            interest_rate,
            collateral,
            state: LoanState::InActive
        }
    }
}

impl Application {
    pub fn new(
        barrower: Indentity,
        requested_amount: u64,
        credit_score: u16
        state: ApplicationState
    ) -> Self {
        Self {
            barrower,
            requested_amount,
            credit_score,
            state: ApplicationState::Pending
        }
    }
}

pub enum ApplicationState {
    Pending: (),
    Approved: (),
    Denied: ()
}

pub enum LoanState {
    Active: (),
    InActive: ()
}