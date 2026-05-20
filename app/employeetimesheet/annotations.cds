using TimesheetService as service from '../../srv/timesheet_service';

/* =========================================================
   STATUS CRITICALITY
========================================================= */

// annotate service.Timesheets with {

//     status @Common.ValueListWithFixedValues;

//     status @UI.Criticality : case
//         when status = 'Approved' then 3
//         when status = 'Rejected' then 1
//         when status = 'Submitted' then 2
//         else 0
//     end;
// };


/* =========================================================
   HEADER INFO
========================================================= */

annotate service.Timesheets with @UI.HeaderInfo : {
    TypeName       : 'Timesheet',
    TypeNamePlural : 'Timesheets',
    Title : {
        Value : weekstartdate
    },
    Description : {
        Value : status
    }
};


/* =========================================================
   LIST REPORT
========================================================= */

annotate service.Timesheets with @UI.LineItem : [

    {
        $Type : 'UI.DataField',
        Label : 'Employee',
        Value : employee.name
    },

    {
        $Type : 'UI.DataField',
        Label : 'Week Start',
        Value : weekstartdate
    },

    {
        $Type : 'UI.DataField',
        Label : 'Total Hours',
        Value : totalhours_computed
    },

    {
        $Type : 'UI.DataField',
        Label : 'Status',
        Value : status,
        Criticality : status
    },

    {
        $Type : 'UI.DataField',
        Label : 'Approved By',
        Value : approvedby.name
    },

    {
        $Type : 'UI.DataFieldForAction',
        Action : 'TimesheetService.submitTimesheet',
        Label : 'Submit'
    }
];


/* =========================================================
   FILTER BAR
========================================================= */

annotate service.Timesheets with @UI.SelectionFields : [
    employee_ID,
    weekstartdate,
    status
];


/* =========================================================
   OBJECT PAGE FACETS
========================================================= */

annotate service.Timesheets with @UI.Facets : [

    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'General Information',
        Target : '@UI.FieldGroup#General'
    },

    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Approval Information',
        Target : '@UI.FieldGroup#Approval'
    },

    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Timesheet Entries',
        Target : 'entries/@UI.LineItem'
    }
];


/* =========================================================
   GENERAL INFORMATION
========================================================= */

annotate service.Timesheets with @UI.FieldGroup #General : {
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
        }
    ]
};


/* =========================================================
   APPROVAL INFORMATION
========================================================= */

annotate service.Timesheets with @UI.FieldGroup #Approval : {
    Data : [

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
};


/* =========================================================
   IDENTIFICATION SECTION
========================================================= */

annotate service.Timesheets with @UI.Identification : [

    {
        $Type : 'UI.DataField',
        Value : weekstartdate
    },

    {
        $Type : 'UI.DataField',
        Value : status
    },

    {
        $Type : 'UI.DataFieldForAction',
        Action : 'TimesheetService.submitTimesheet',
        Label : 'Submit Timesheet'
    }
];


/* =========================================================
   TIMESHEET ENTRY TABLE
========================================================= */

annotate service.TimesheetEntries with @UI.LineItem : [

    {
        $Type : 'UI.DataField',
        Label : 'Entry Date',
        Value : entrydate
    },

    {
        $Type : 'UI.DataField',
        Label : 'Work Package',
      Value : workpackages_ID
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
];


/* =========================================================
   ENTRY OBJECT PAGE
========================================================= */

annotate service.TimesheetEntries with @UI.FieldGroup #EntryDetails : {
    Data : [

        {
            $Type : 'UI.DataField',
            Label : 'Entry Date',
            Value : entrydate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Work Package',
            Value : workpackages_ID
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
};


/* =========================================================
   VALUE HELPS
========================================================= */

annotate service.Timesheets with {

    employee @Common.ValueList : {
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : employee_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

    approvedby @Common.ValueList : {
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : approvedby_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };
};


/* =========================================================
   WORKPACKAGE VALUE HELP
========================================================= */

annotate service.TimesheetEntries with {

    workpackages @Common.ValueList : {
        CollectionPath : 'Workpackages',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : workpackages_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'title'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'status'
            }
        ]
    };
};


/* =========================================================
   READ ONLY FIELDS
========================================================= */

annotate service.Timesheets with {

    totalhours_computed @Core.Computed;

    status @Core.Computed;

    approvedby @Core.Computed;
};


/* =========================================================
   HIDE TECHNICAL FIELDS
========================================================= */

annotate service.Timesheets with {

    createdAt  @UI.HiddenFilter;
    createdBy  @UI.HiddenFilter;
    modifiedAt @UI.HiddenFilter;
    modifiedBy @UI.HiddenFilter;
};


/* =========================================================
   ENTRY CREATION SUPPORT
========================================================= */

annotate service.Timesheets with @UI.CreateHidden : false;
annotate service.TimesheetEntries with @UI.CreateHidden : false;