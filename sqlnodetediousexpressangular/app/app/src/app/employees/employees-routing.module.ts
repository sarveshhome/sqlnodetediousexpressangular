import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { EmployeesComponent } from './employees.component';
import { EmpdetailsComponent } from './empdetails/empdetails.component';

const routes: Routes = [
  { path: 'details/:id', component: EmpdetailsComponent },
  { path: '', component: EmployeesComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class EmployeesRoutingModule { }
