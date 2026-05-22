namespace Timesheet_management;

using {managed} from '@sap/cds/common';

type timesheetstatus            : String enum {
    Draft;
    Submitted;
    Approved;
    Rejected
};

type workpackagestatus : String enum {
    Open;
    Inprogresss;
    Completed
}

type projectstatus     : String enum {

    Planned;
    Active;
    Onhold;
    Completed;
    Cancelled;
};


entity Employees : managed {
    key ID         : UUID;
        empno      : String;
        name       : String;
        email      : String;
        department : String;
        hourlyrate : Decimal(16, 3);
        skills     : String;
        utilization_computed : Decimal(5,2);
        projects:Association to Projects;

};


entity Projects : managed {
    key ID             : UUID;
        projectcode    : String;
        name           : String;
        client         : String;
        startdate      : Date;
        enddate        : Date;
        budget         : Decimal(16, 3);

        
        status         : projectstatus;
        actualbudget_computed : Decimal(16,3);
variance_computed : Decimal(16,3);
workpackages : Composition of many Workpackages
                   on workpackages.project = $self;
             employee:Association to  many  Employees on employee.projects=$self      
};


entity Workpackages : managed {

    key ID                   : UUID;
        wpcode               : String;
        title                : String;
        plannnedHours        : Decimal(5, 2);
        actualhours_computed : Decimal(5, 2);
        status               : workpackagestatus;
        assignedto           : Association to Employees;
      timesheetEntries : Association to many TimesheetEntries
    on timesheetEntries.workpackages = $self;
        project : Association to Projects;
        

}


entity Timesheets : managed {

    key ID                  : UUID;

        employee            : Association to Employees;

        weekstartdate       : Date;

        status              : timesheetstatus default 'Draft';

        totalhours_computed : Decimal(5, 2) default 0;

        approvedby          : Association to Employees;

        entries             : Composition of many TimesheetEntries
                                  on entries.timesheet = $self;
         comments: String;
                virtual statusCriticality : Integer;


}

entity TimesheetEntries : managed {

    key ID           : UUID;

        entrydate    : Date;

        hours        : Decimal(4, 2);

        description  : String;

        timesheet    : Association to  Timesheets;

        workpackages : Association to Workpackages
}



