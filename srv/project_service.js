
const cds=require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports=cds.service.impl(async function(){
   const {Employees,Projects,Workpackages}=this.entities

   this.on('startProject',async(req)=>{
        const {ID}=req.data

        console.log(ID," id from req")
       const  data=    await UPDATE(Projects).set({ status:"Planne"}).where({ID})

        const changeddata=  await SELECT.one.from(Projects).where({ID})

        return changeddata

   })

   
   this.on('completeProject',async function(req){
   
console.log("id from completestatus",req.data)
 const{ID}=req.data

    const isvalidID= await SELECT.one.from(Projects).where(ID)
         if(!isvalidID) req.error("404","usernot found")

            const data= await UPDATE(Projects).set({status:"Completed"}).where(ID)


           const afterupdate=await SELECT.one.from(Projects).where(ID)
            return afterupdate
   })



})