using ProjectService as service from '../../srv/project_service';


annotate service.Timesheets with @(

    UI.HeaderInfo : {
        TypeName : 'Timesheet',
        TypeNamePlural : 'Timesheets',

        Title : {
            $Type : 'UI.DataField',
            Value : employee.name
        },

        Description : {
            $Type : 'UI.DataField',
            Value : status
        }
    },



 

    UI.SelectionFields : [
        status,
        weekstartdate
    ],





    UI.LineItem : [

     

        {
            $Type : 'UI.DataField',
            Label : 'Week Start Date',
            Value : weekstartdate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
                Criticality : statusCriticality
        },

        {
            $Type : 'UI.DataField',
            Label : 'Total Hours',
            Value : totalhours_computed
        },

        {
            $Type : 'UI.DataField',
            Label : 'Comments',
            Value : comments
        }
    ],



  

    UI.Identification : [

        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Approve',

            Action : 'ProjectService.approveTimesheet'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Reject',

            Action : 'ProjectService.rejectTimesheet'
        }
    ],




    UI.Facets : [

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneralInformation'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Timesheet Entries',
            Target : 'entries/@UI.LineItem'
        }
    ],



   

    UI.FieldGroup #GeneralInformation : {

        $Type : 'UI.FieldGroupType',

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Employee',
                Value : employee.name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Week Start Date',
                Value : weekstartdate
            },

            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status
            },

            {
                $Type : 'UI.DataField',
                Label : 'Total Hours',
                Value : totalhours_computed
            },

            {
                $Type : 'UI.DataField',
                Label : 'Approved By',
                Value : approvedby.name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Comments',
                Value : comments
            }
        ]
    }
);



annotate service.Timesheets with @(
    UI.DeleteHidden : true
);

annotate service.TimesheetEntries with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Work Package',
            Value : workpackages.title
        },

        {
            $Type : 'UI.DataField',
            Label : 'Entry Date',
            Value : entrydate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Hours',
            Value : hours
        },

        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description
        }
    ]
);