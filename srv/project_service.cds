using { Timesheet_management as db } from '../db/schema';

service ProjectService {

    entity Employees as projection on db.Employees;

    entity Projects as projection on db.Projects;

    entity Workpackages as projection on db.Workpackages actions {

        action assignWorkpackage(
            workpackageID : UUID,
            employeeID    : UUID
        ) returns String;
    };


  
    entity Timesheets as projection on db.Timesheets {
        *,
        entries
    }
    actions {

        action approveTimesheet() returns String;

        action rejectTimesheet(
            comments : String
        ) returns String;
    };


    entity TimesheetEntries as projection on db.TimesheetEntries {
        *,
        workpackages,
        timesheet
    };


    action startProject(ID : UUID) returns String;

    action completeProject(ID : UUID) returns String;
action getBudgetVariance(projectID : UUID) returns Decimal(16,3);
}