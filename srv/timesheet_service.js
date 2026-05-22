const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {

    const {
        Timesheets,
        TimesheetEntries,
        Workpackages
    } = this.entities

    
const cds = require('@sap/cds')

   this.after('READ', 'Timesheets', (data) => {

    const rows = Array.isArray(data) ? data : [data];

    for (const row of rows) {

        row.statusCriticality =
            row.status === 'Approved' ? 3 :
            row.status === 'Submitted' ? 2 :
            row.status === 'Rejected' ? 1 :
            row.status ==='Draft'?5:
            0;
    }
});

    this.before('submitTimesheet', async (req) => {

        const ID = req.params[0].ID

    
        const isvalid = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        if (!isvalid) {
            return req.error(404, 'Timesheet not found')
        }

     
        const entries = await SELECT
            .from(TimesheetEntries)
            .where({ timesheet_ID: ID })

     
        let totalhours = 0

        for (const entry of entries) {

            totalhours += Number(entry.hours)

           
            const wp = await SELECT.one
                .from(Workpackages)
                .where({ ID: entry.workpackages_ID })

            if (!wp) {
                return req.error(400, 'Invalid Workpackage')
            }
        }

      
        await UPDATE(Timesheets)
            .set({
                totalhours_computed: totalhours
            })
            .where({ ID })

        if (totalhours < 1) {
            return req.error(400, 'Total hours must be greater than 0')
        }

        if (totalhours > 40) {
            return req.error(400, 'Total hours should not exceed 40')
        }

    })


    this.on('submitTimesheet', Timesheets, async (req) => {

        const ID = req.params[0].ID;

        const tx = cds.transaction(req);

        const timesheet = await tx.run(
            SELECT.one.from(Timesheets).where({ ID })
        );

        if (!timesheet) {
            req.error(404, 'Timesheet not found');
        }

        if (timesheet.status !== 'Draft') {
            req.error(400, 'Only Draft timesheets can be submitted');
        }

        await tx.run(
            UPDATE(Timesheets)
                .set({
                    status : 'Submitted'
                })
                .where({ ID })
        );

        return 'Timesheet Submitted Successfully';
    });

    this.on('approveTimesheet', 'Timesheets', async (req) => {

        const ID = req.params[0].ID

        const isidvalid = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        if (!isidvalid) {
            return req.error(404, 'Timesheet not found')
        }

        await UPDATE(Timesheets)
            .set({
                status: 'Approved'
            })
            .where({ ID })

        const data = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        return data
    })

    this.on('rejectTimesheet', 'Timesheets', async (req) => {

        const ID = req.params[0].ID
        const { comments } = req.data

        const isvalid = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        if (!isvalid) {
            return req.error(404, 'Timesheet not found')
        }

        await UPDATE(Timesheets)
            .set({
                status: 'Rejected',
                comments: comments
            })
            .where({ ID })

        const data = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        return data
    })

})