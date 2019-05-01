# ddm

User settings:
    trackLocation:true
    hideRegister:true
    hideEnrol:true
    hideExit:true
    hideUnplanned:false
    locale:mr_IN

    set role ddm;
    update users set settings = '{"trackLocation":true,"hideRegister":true,"hideEnrol":true,"hideExit":true,"hideUnplanned":false,"locale":"mr_IN"}',
        last_modified_date_time = current_timestamp, last_modified_by_id = 91;
