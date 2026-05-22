




const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {

    const {
        Timesheets
    } = this.entities




    this.on("assignWorkpackage", async (req) => {

        const { workpackageID, employeeID } = req.data;

        await UPDATE(Workpackages)
            .set({ assignedto_ID: employeeID })
            .where({ ID: workpackageID });

        return "Workpackage Assigned";
    });

    this.on("startProject", async (req) => {

     const ID = req.data.ID || req.params?.[0]?.ID;

        await UPDATE(Projects)
            .set({ status: "Active" })
            .where({ ID });

        return "Project Started";
    });

    this.on("completeProject", async (req) => {
const ID = req.data.ID || req.params?.[0]?.ID;

        await UPDATE(Projects)
            .set({ status: "Completed" })
            .where({ ID });

        return "Project Completed";
    });
    this.on('approveTimesheet', async (req) => {

        const ID = req.params[0].ID

        const timesheet = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        if (!timesheet) {
            return req.error(404, 'Timesheet Not Found')
        }

        await UPDATE(Timesheets)
            .set({
                status: 'Approved'
            })
            .where({ ID })

        return 'Timesheet Approved Successfully'
    })
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


    

    this.on('rejectTimesheet', async (req) => {

        const ID = req.params[0].ID

        const { comments } = req.data

        const timesheet = await SELECT.one
            .from(Timesheets)
            .where({ ID })

        if (!timesheet) {
            return req.error(404, 'Timesheet Not Found')
        }

        await UPDATE(Timesheets)
            .set({
                status: 'Rejected',
                comments: comments
            })
            .where({ ID })

        return 'Timesheet Rejected Successfully'
    })

    this.on('getBudgetVariance', async (req) => {

        const { projectID } = req.data;

      
        const project = await SELECT.one
            .from(Projects)
            .where({ ID: projectID });

        if (!project) {
            return req.error(404, 'Project not found');
        }

        const entries = await SELECT.from(TimesheetEntries).columns(
            'hours',
            {
                timesheet: [
                    {
                        employee: ['hourlyrate']
                    }
                ]
            },
            {
                workpackages: ['project_ID']
            }
        ).where({
            workpackages: {
                project_ID: projectID
            }
        });

        let actualCost = 0;

    
        for (const entry of entries) {

            const hours = Number(entry.hours || 0);

            const rate = Number(
                entry.timesheet?.employee?.hourlyrate || 0
            );

            actualCost += hours * rate;
        }

   
        const budget = Number(project.budget || 0);

        const variance = budget - actualCost;

     
        await UPDATE(Projects)
            .set({
                actualbudget_computed: actualCost,
                variance_computed: variance
            })
            .where({ ID: projectID });

        return variance;
    });

});

