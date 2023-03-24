library errors;

pub enum InitError {
    CannotReinitialize: (),
    NotInitialized: ()
}

pub enum AccessControlError {
    OnlyAdminsCanAccess: (),
    ApplicationNotApproved: ()
}