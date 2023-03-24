library errors;

pub enum InitError {
    CannotReinitialize: (),
    NotInitialized: ()
}

pub enum AccessControlError {
    OnlyAdminsCanAccess: (),
    ApplicationNotApproved: ()
}

pub enum LoanErrors {
    CollateralRequirmentsUnmet: ()
}