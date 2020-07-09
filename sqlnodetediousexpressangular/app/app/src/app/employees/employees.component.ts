import { Component, OnInit } from '@angular/core';
import { EmpService } from '../emp.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-employees',
  templateUrl: './employees.component.html',
  styleUrls: ['./employees.component.css']
})
export class EmployeesComponent implements OnInit {

  employees=[];
  constructor(private empService: EmpService,private route:Router) { }

  ngOnInit(): void {
    this.empService.getEmployees().subscribe(
      (data)=> {
        this.employees = data;
        console.log(this.employees);
      }
    )
  }
  navigateempDetails(data){
     console.log(data);
     this.route.navigateByUrl('employees/details/'+data);
  }

}
