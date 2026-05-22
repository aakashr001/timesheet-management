using TimesheetService as service from '../../srv/timesheet_service';



annotate service.Timesheets with @(

    UI.HeaderInfo : {
        TypeName       : 'Timesheet',
        TypeNamePlural : 'Timesheets',

        Title : {
            Value : weekstartdate
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



    UI.FieldGroup #GeneratedGroup : {

        $Type : 'UI.FieldGroupType',

        Data : [

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
                Label : 'Comments',
                Value : comments
            }
        ]
    },



    UI.Facets : [

        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'GeneralInformation',
            Label  : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup'
        },

        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'EntriesFacet',
            Label  : 'Entries',
            Target : 'entries/@UI.LineItem'
        }
    ],



    UI.Identification : [

        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Submit',
            Action : 'TimesheetService.submitTimesheet'
        }
    ]
);










annotate service.Timesheets actions {

    submitTimesheet @(
        Common.SideEffects : {
            TargetProperties : [
                'status',
                'totalhours_computed'
            ]
        }
    );

};




annotate service.Workpackages with {

    ID @Common.Text : title;

};




annotate service.TimesheetEntries with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Work Package',
       Value : workpackages_ID
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
    ],



    UI.FieldGroup #EntryDetails : {

        $Type : 'UI.FieldGroupType',

        Data : [

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
    },



    UI.Facets : [

        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'Entry Details',
            Target : '@UI.FieldGroup#EntryDetails'
        }

    ]

);




annotate service.TimesheetEntries with {

    workpackages @(

        Common.Text : workpackages.title,

        Common.ValueList : {

            Label : 'Work Package',

            CollectionPath : 'Workpackages',

            Parameters : [

                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : workpackages_ID,
                    ValueListProperty : 'ID'
                },

                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'title'
                },

                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'wpcode'
                }

            ]
        }
    );

};

annotate service.Timesheets with {

    status @Common.FieldControl : #ReadOnly;

    totalhours_computed @Common.FieldControl : #ReadOnly;
    comments @Common.FieldControl : #ReadOnly;

};