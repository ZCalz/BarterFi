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
    barrower: Identity,
    amount: u64,
    interest_rate: u8,
    collateral: u64,
    state: LoanState,
}

pub struct Application {
    barrower: Identity,
    requested_amount: u64,
    credit_score: u16,
    state: ApplicationState,
    loan_id: Option<u64>,
}

impl Loan {
    pub fn new(
        application_id: u64,
        barrower: Identity,
        amount: u64,
        interest_rate: u8,
        collateral: u64,
    ) -> Self {
        Self {
            application_id,
            barrower,
            amount,
            interest_rate,
            collateral,
            state: LoanState::InActive,
        }
    }
}

impl Application {
    pub fn new(barrower: Identity, requested_amount: u64, credit_score: u16) -> Self {
        Self {
            barrower,
            requested_amount,
            credit_score,
            state: ApplicationState::Pending,
            loan_id: Option::None,
        }
    }
}

pub enum ApplicationState {
    Pending: (),
    Approved: (),
    Denied: (),
}

pub enum LoanState {
    Active: (),
    InActive: (),
}
