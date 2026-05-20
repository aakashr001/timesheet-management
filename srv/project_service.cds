
using {Timesheet_management as db} from '../db/schema';



service ProjectService{

    entity Employees  as projection on db.Employees;
    entity Projects as projection on db.Projects actions{
     
    };
    entity Workpackages as projection on db.Workpackages;
       action startProject(ID:UUID) returns String;
     action completeProject(ID:UUID) returns String
}











