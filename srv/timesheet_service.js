const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {

    const {
        Timesheets,
        TimesheetEntries,
        Workpackages
    } = this.entities

    
const cds = require('@sap/cds')



    this.before('submitTimesheet', async (req) => {

        const ID = req.params[0].ID

        // Check timesheet exists
        const isvalid = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        if (!isvalid) {
            return req.error(404, 'Timesheet not found')
        }

        // Fetch entries
        const entries = await SELECT
            .from(TimesheetEntries)
            .where({ timesheet_ID: ID })

        // Calculate total hours
        let totalhours = 0

        for (const entry of entries) {

            totalhours += Number(entry.hours)

            // Validate workpackage
            const wp = await SELECT.one
                .from(Workpackages)
                .where({ ID: entry.workpackages_ID })

            if (!wp) {
                return req.error(400, 'Invalid Workpackage')
            }
        }

        // Update computed total
        await UPDATE(Timesheets)
            .set({
                totalhours_computed: totalhours
            })
            .where({ ID })

        // Validation
        if (totalhours < 1) {
            return req.error(400, 'Total hours must be greater than 0')
        }

        if (totalhours > 40) {
            return req.error(400, 'Total hours should not exceed 40')
        }

    })


    this.on('submitTimesheet', 'Timesheets', async (req) => {

        const ID = req.params[0].ID

        await UPDATE(Timesheets)
            .set({
                status: 'Submitted'
            })
            .where({ ID })

        const updatedvalue = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        return updatedvalue
    })

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