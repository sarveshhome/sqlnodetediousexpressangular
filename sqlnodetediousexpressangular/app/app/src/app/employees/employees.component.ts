import { Component, OnInit } from '@angular/core';
import { EmpService } from '../emp.service';

@Component({
  selector: 'app-employees',
  templateUrl: './employees.component.html',
  styleUrls: ['./employees.component.css']
})
export class EmployeesComponent implements OnInit {

  employees=[];
  constructor(private empService: EmpService) { }

  ngOnInit(): void {
    this.empService.getEmployees().subscribe(
      (data)=> {
        this.employees = data;
        console.log(this.employees);
      }
    )
  }

}
