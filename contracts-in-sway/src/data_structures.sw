library data_structures;

pub struct Loan {
    loan_id: u64,
    barrower: Indentity,
    amount: u64,
    interest_rate: u64,
    collateral: u64
}

pub struct Application {
    barrower: Indentity,
    requested_amount: u64,
    credit_score: u16
}