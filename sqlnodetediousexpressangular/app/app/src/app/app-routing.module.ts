import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { EmpService } from './emp.service';


const routes: Routes = [
  { path: 'employees', loadChildren: () => import('./employees/employees.module').then(m => m.EmployeesModule) },
  { path: '', pathMatch: 'full', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [EmpService]
})
export class AppRoutingModule { }
