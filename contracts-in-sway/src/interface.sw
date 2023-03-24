library interface;

abi Barterfi {
    #[storage(read, write)]
    fn apply_for_loan();

    #[storage(read, write)]
    fn approve_loan();

    #[storage(read, write)]
    fn provide_collateral();

    #[storage(read, write)]
    fn fund_loan();

    #[storage(read, write)]
    fn estimate_interest();
}