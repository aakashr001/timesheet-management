sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"timesheet/employeetimesheet/test/integration/pages/TimesheetsList",
	"timesheet/employeetimesheet/test/integration/pages/TimesheetsObjectPage"
], function (JourneyRunner, TimesheetsList, TimesheetsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('timesheet/employeetimesheet') + '/test/flp.html#app-preview',
        pages: {
			onTheTimesheetsList: TimesheetsList,
			onTheTimesheetsObjectPage: TimesheetsObjectPage
        },
        async: true
    });

    return runner;
});

