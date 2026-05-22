sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"mnagerdashboard/test/integration/pages/TimesheetsList",
	"mnagerdashboard/test/integration/pages/TimesheetsObjectPage",
	"mnagerdashboard/test/integration/pages/TimesheetEntriesObjectPage"
], function (JourneyRunner, TimesheetsList, TimesheetsObjectPage, TimesheetEntriesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('mnagerdashboard') + '/test/flp.html#app-preview',
        pages: {
			onTheTimesheetsList: TimesheetsList,
			onTheTimesheetsObjectPage: TimesheetsObjectPage,
			onTheTimesheetEntriesObjectPage: TimesheetEntriesObjectPage
        },
        async: true
    });

    return runner;
});

