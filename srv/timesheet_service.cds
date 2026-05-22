


using {Timesheet_management as db } from '../db/schema';

service TimesheetService{
@restrict:[
    {
        grant:['*'],
        to:'Employee'
    }
  ]
  @odata.draft.enabled
  entity Timesheets as projection on db.Timesheets{
    *,    entries  }
 actions {
      action submitTimesheet() returns String;

    };
      entity TimesheetEntries as projection on db.TimesheetEntries {
      *,
      workpackages,
      timesheet
  };
  entity Workpackages as projection on db.Workpackages


   

}


