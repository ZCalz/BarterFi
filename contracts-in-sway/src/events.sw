library events;

pub enum ApplicationStatusEvent {
    ApplicationApproved: (),
    ApplicationRejected: ()
}

pub enum LoanStatusEvent {
    CollateralProvided: (),
    LoanFunded:(),
    LoanPayedBack: ()
}